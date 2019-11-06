function [Lasso]=Leo_RSFC_LASSO(behav_measure, Network,Network2, covariates_in, feature_behav)
addpath(genpath('A:\MATLAB_PATH'))

%% PATHS AND FLAGS
%flags
flags.z_score_timecourse=1; %whether or not we aim to z-score our time-course
flags.top_connections=-1; %Use -1 if you'd like to create one robustly based on number of features.
flags.preproc_str='clean_data';
flags.regress_out=covariates_in; %cell-array of covariates to regress out.%paths
flags.num_shuffles=50;
paths.top_dir='A:\Leo\';
paths.raw_data=[paths.top_dir 'Data/'];
paths.masks=[paths.top_dir '/Masks'];
paths.reference=[paths.top_dir 'Reference/'];
n_out=10;

if ~isempty(Network2)
    Network_String=[Network '_and_' Network2];
else
    Network_String=[Network];
end
    
if ~strcmp(flags.regress_out,'none')
    
    if size(covariates_in,1) >1
        covariate_str=[];
        for i=1:size(covariates_in,1)
        covariate_str=[covariate_str '_' covariates_in{i}];
        end
    else
        covariate_str=[];
        covariate_str=[covariate_str '_' covariates_in{1}];
    end
    
paths.save_file=[paths.top_dir 'Results/' behav_measure '_' Network_String '_Regressing_Out_' covariate_str '_LASSO_with_' feature_behav{1} '.txt'];
else
paths.save_file=[paths.top_dir 'Results/' behav_measure '_' Network_String '_No_Covariates_LASSO_with_' feature_behav{1} '.txt'];
end

paths.save_corrs=[paths.top_dir '/Corr_Matrices/All_Subjects_' Network];
%% BRING IN DATA AND FORM RAW PATTERNS
load([paths.reference 'subj_IDs.mat']) %an output of gather_and_organize.m that will load in a cell array names "active_subjs"

counter=1;
active_subjs=[];
if ~exist(([paths.reference 'All_Subj_264_Mean_TimeCourse.mat']))
    
    for s=1:size(subj_IDs,1)

        try
            load([paths.raw_data num2str(subj_IDs(s)) '/' flags.preproc_str '_tc.mat']) %an output of gather_and_organize.m that will load in a matrix of subject's resting state data named "raw_image"
             catch
           active_subjs=[active_subjs 0];
            continue
        end
            
            Subj_Patterns{counter}=[];
            active_subjs=[active_subjs 1];
            disp(['Reshaping and Z Scoring For Subject ' num2str(subj_IDs(s))])
            for t=1:size(bold_tc,4)
                Subj_Patterns{counter}=horzcat(Subj_Patterns{counter}, reshape_to_1(bold_tc(:,:,:,t))); %create a matrix of voxels(rows) x time(columns)
            end
            
            if flags.z_score_timecourse==1 %z-score across time if we are so inclined.
                for z=1:size(Subj_Patterns{counter},1)
                    Subj_Patterns{counter}(z,:)=zscore(Subj_Patterns{counter}(z,:));
                end
            end
            counter=counter+1;
    end
        
%% Make a mean time course across all nodes
for m=1:264
    V=spm_vol([paths.masks 'Petersen_', num2str(m), '.nii' ]);
    node_mask_indices{m}=find(spm_read_vols(V));
end

subj_IDs=subj_IDs(find(active_subjs));


for s=1:size(subj_IDs,1)
    for m=1:size(node_mask_indices,2)
        mean_tc{s}(m,:)=mean(Subj_Patterns{s}(node_mask_indices{m},:),1);
    end
end

save([paths.reference 'All_Subj_264_Mean_TimeCourse'], 'mean_tc','active_subjs')
clear node_mask_indices Subj_Patterns

else
    load([paths.reference 'All_Subj_264_Mean_TimeCourse'])
    subj_IDs=subj_IDs(find(active_subjs));
end



%% Bring in the masks of interest and mask patterns for mean-time-course
load([paths.reference 'Petersen_Network_Indices.mat'])
network_of_interest=Petersen_Networks.(Network);

if ~isempty(Network2)
     network_of_interest=vertcat(network_of_interest,Petersen_Networks.(Network2));
end

for s=1:size(subj_IDs,1) 
        temp_corr_matrix=tril(corr(mean_tc{s}(network_of_interest,:)'),-1);
        mask=ones(size(temp_corr_matrix));
        mask=tril(mask,-1);
        % Here is where we can further index the mask to allow only
        % specific subsets of nodes (i.e networks)
        patterns{s}=temp_corr_matrix(find(mask));  
end

%% Create Classification Patterns

classification_patterns=cell2mat(patterns);

clear patterns
clear Subj_Patterns


if ~strcmp(feature_behav{1},'none')
    for fb=1:size(feature_behav,2)
        load([paths.reference feature_behav{fb} '.mat'])
        behav_vector=behav_vector(find(active_subjs),:);
        behav_vector=behav_vector';
        %QA the Behavioral Data and Update the classification patterns as needed.
        no_behav=find(behav_vector==999); %999 is hard coding to continue using vectors but include missing data
        behav_vector(no_behav)=[];
        classification_patterns(:,no_behav)=[];
        active_subjs(no_behav)=0;
        classification_patterns=[classification_patterns; behav_vector];%Add the behav to the set of patterns.
    end
end


%% Align Dependent Variable
load([paths.reference behav_measure '.mat'])
behav_vector=behav_vector(find(active_subjs),:);
behav_vector=behav_vector';
%QA the Behavioral Data and Update the classification patterns as needed.
no_behav=find(behav_vector==9999); %999 is hard coding to continue using vectors but include missing data
behav_vector(no_behav)=[];
classification_patterns(:,no_behav)=[];
active_subjs(no_behav)=0;
test_behav=behav_vector;


%% Regress out Potential Co-Variates
if ~strcmp(flags.regress_out,'none')
covariates=[];
for cov=1:numel(flags.regress_out)
    load([paths.reference flags.regress_out{cov} '.mat'])
    covariates=horzcat(covariates,behav_vector);
end
covariates=covariates(find(active_subjs),:);

for p=1:size(classification_patterns,1)
[b,bint,regressed_out(:,p)] = regress(classification_patterns(p,:)',covariates);
end
classification_patterns=regressed_out';
end

%% CREATE A CROSS-VALIDATION
%bring back the testing behav vector (need to rename that to be
%non-redundant)
behav_vector=test_behav;
%create a set of selectors for the valid subjects

running_Betas=zeros(size(classification_patterns,1),1);
master_lasso=zeros(1,size(classification_patterns,2));
all_lasso=[];

for ni=1:flags.num_shuffles

uneven=rem(size(test_behav,2),n_out);
num_normal=(size(test_behav,2)-uneven)/n_out;

shuff_idx=shuffle(1:length(test_behav));


all_sel=[];
for sel=1:num_normal
    all_sel=[all_sel, ones(1,n_out)*sel];
end

if uneven %means that we can't divide it evenly
all_sel=[all_sel, ones(1,uneven)*(sel+1)];
end    
    
for sel=unique(all_sel)
    selectors{sel}=ones(1,size(all_sel,2));
    selectors{sel}(shuff_idx(find(all_sel==sel)))=2;
end


%% Classification

for n=1:size(selectors,2)
    disp(['On X-Val Number ' num2str(n) ])
    current_selector=selectors{n};
    train_idx = find(current_selector==1);
    test_idx  = find(current_selector==2);
    
    train_labels=test_behav(:,train_idx);
    test_labels=test_behav(:,test_idx);
    
    train_pats=classification_patterns(:,train_idx);
    test_pats=classification_patterns(:,test_idx);
    
    %LASSO
    [B fitinfo]=lasso(train_pats',train_labels,'Lambda',.002);
    %[B fitinfo]=lasso(train_pats',train_labels);

    for p=1:length(test_labels)
        for l=1:size(B,2)
            Betas=B(:,l);
        lasso_acts{l}(test_idx(p))=sum(test_pats(:,p).*Betas)+fitinfo.Intercept(l);
        end
    end
    
end

master_lasso=master_lasso+cell2mat(lasso_acts);
all_lasso=[all_lasso;cell2mat(lasso_acts)];

end

%Lasso=mean(cell2mat(Lasso));

A=[(master_lasso/flags.num_shuffles)', test_behav'];

Lasso=corr(A(:,1),A(:,2))
scatter(A(:,1),A(:,2));

RMSE = sqrt(mean((A(:,2) - A(:,1)).^2));



header='Lasso r-value';
data=Lasso;
save_data_with_headers(header,data,paths.save_file)

end





