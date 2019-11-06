function gather_and_organize()
data_dir='/space/raid6/data/rissman/Nicco/Leo/Data/';
save_dir='/space/raid6/data/rissman/Nicco/Leo/Data/';

load('/space/raid6/data/rissman/Nicco/Leo/Reference/subj_IDs.mat')
 
for s=1:size(subj_IDs,1)
    
    subject_ID=num2str(subj_IDs(s));
    
    cur_file=[data_dir subject_ID '/clean_data.nii'];
    
    if ~exist(cur_file)
        try
        gunzip([cur_file '.gz'])
        delete([cur_file '.gz'])
        catch
            continue
        end
    end
    
    temp_read_in=spm_vol(cur_file);
    temp_3D=spm_file_split(temp_read_in); %%SPM no gusta 4D files. Make them 3D and put them in a variable that seems similar to  a 4D
    disp(sprintf(['Populating the bold timecourse array for Subject ' subject_ID]))
    for e=1:length(temp_3D)
        format long
        bold_tc(:,:,:,e)=spm_read_vols(temp_3D(e));
    end
    disp('Cleaning Up The directory after Splitting')
    delete([data_dir subject_ID '/*_00*'])
    
  
   save_name=[save_dir subject_ID '/clean_data_tc.mat'];
   save(save_name,'bold_tc','-v7.3')
 
    
end
   
end




