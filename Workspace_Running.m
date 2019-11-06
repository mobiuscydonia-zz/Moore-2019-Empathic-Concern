networks={'Resonance','Control','Visual','Salience','Uncertain','Memory_Retrieval','Ventral_Attention','Cingulo_Opercular','Sensory_Somatomotor','Fronto_Parietal','Default_Mode', 'Dorsal_Attention','Subcortical'}; 
%networks={'Default_Mode','Visual','Control'}; 
%'HBM_2016','Default_Mode','Default_Mode_L','Default_Mode_R','Fronto_Parietal_L','Fronto_Parietal_R'};
behavs={'Empathic_Concern'}; % , 'Perspective_Taking','Personal_Distress' , 'Fantasizing'}; %'HSES','LSES','ASES'

%Individual Networks SVM
for n=1:size(networks,2)
disp(['*~*~*~*~*~*~*~*~Two-Way Classification With: ' networks{n}])
Leo_RSFC_SVM('gender',networks{n},[],'none',{'none'});
Leo_RSFC_SVM('gender',networks{n},[],'none',{'avg_grayvol'});
end

%Individual Networks SVM
for n=1:size(networks,2)
disp(['*~*~*~*~*~*~*~*~Two-Way Classification With: ' networks{n}])
Leo_RSFC_SVM('gender',networks{n},[],{'avg_grayvol'},{'none'});
end

%Across Network SVM
disp(['*~*~*~*~*~*~*~*~Two-Way Classification With Across Networks'])
Leo_RSFC_SVM('gender','Visual','Fronto_Parietal',{'avg_grayvol'});
Leo_RSFC_SVM('gender','Sensory_Somatomotor','Fronto_Parietal',{'avg_grayvol'});
Leo_RSFC_SVM('gender','Default_Mode','Visual',{'avg_grayvol'});
Leo_RSFC_SVM('gender','Resonance','Control',{'avg_grayvol'});
Leo_RSFC_SVM('gender','Resonance','Visual',{'avg_grayvol'});
Leo_RSFC_SVM('gender','Default_Mode','Cingulo_Opercular',{'avg_grayvol'});
Leo_RSFC_SVM('gender','Visual','Control',{'avg_grayvol'});
Leo_RSFC_SVM('gender','Sensory_Somatomotor','Visual',{'avg_grayvol'});


%Across Network SVM
disp(['*~*~*~*~*~*~*~*~Two-Way Classification With Across Networks'])
Leo_RSFC_SVM('gender','Visual','Fronto_Parietal','none',{'avg_grayvol'});
Leo_RSFC_SVM('gender','Sensory_Somatomotor','Fronto_Parietal','none',{'avg_grayvol'});
Leo_RSFC_SVM('gender','Default_Mode','Visual','none',{'avg_grayvol'});
Leo_RSFC_SVM('gender','Resonance','Control','none',{'avg_grayvol'});
Leo_RSFC_SVM('gender','Resonance','Visual','none',{'avg_grayvol'});
Leo_RSFC_SVM('gender','Default_Mode','Cingulo_Opercular','none',{'avg_grayvol'});
Leo_RSFC_SVM('gender','Visual','Control','none',{'avg_grayvol'});
Leo_RSFC_SVM('gender','Sensory_Somatomotor','Visual','none',{'avg_grayvol'});


%Across Network SVM
disp(['*~*~*~*~*~*~*~*~Two-Way Classification With Across Networks'])
Leo_RSFC_SVM('gender','Visual','Fronto_Parietal',{'avg_grayvol'},{'none'});
Leo_RSFC_SVM('gender','Sensory_Somatomotor','Fronto_Parietal',{'avg_grayvol'},{'none'});
Leo_RSFC_SVM('gender','Default_Mode','Visual',{'avg_grayvol'},{'none'});
Leo_RSFC_SVM('gender','Resonance','Control',{'avg_grayvol'},{'none'});
Leo_RSFC_SVM('gender','Resonance','Visual',{'avg_grayvol'},{'none'});
Leo_RSFC_SVM('gender','Default_Mode','Cingulo_Opercular',{'avg_grayvol'},{'none'});
Leo_RSFC_SVM('gender','Visual','Control',{'avg_grayvol'},{'none'});
Leo_RSFC_SVM('gender','Sensory_Somatomotor','Visual',{'avg_grayvol'},{'none'});



%Individual Network LASSO
for n=1:size(networks,2)
for b=1:size(behavs,2)
disp(['*~*~*~*~*~*~*~*~ON NETWORK: ' networks{n}])
disp(['*~*~*~*~*~*~*~*~*~*~AND BEHAV: ' behavs{b}])
Leo_RSFC_LASSO(behavs{b},networks{n},[],{'gender'},{'none'});
end
end


%Across Network LASSO
for b=1:size(behavs,2)
disp(['*~*~*~*~*~*~*~*~*~*~ON BEHAV: ' behavs{b}])
Leo_RSFC_LASSO(behavs{b},'Visual','Fronto_Parietal',{'gender'},{'none'});

Leo_RSFC_LASSO(behavs{b},'Sensory_Somatomotor','Fronto_Parietal',{'gender'},{'none'});

Leo_RSFC_LASSO(behavs{b},'Sensory_Somatomotor','Visual',{'gender'},{'none'});

Leo_RSFC_LASSO(behavs{b},'Default_Mode','Visual',{'gender'},{'none'});

Leo_RSFC_LASSO(behavs{b},'Resonance','Control',{'gender'},{'none'});

Leo_RSFC_LASSO(behavs{b},'Resonance','Visual',{'gender'},{'none'});

Leo_RSFC_LASSO(behavs{b},'Default_Mode','Cingulo_Opercular',{'gender'},{'none'})

Leo_RSFC_LASSO(behavs{b},'Visual','Control',{'gender'},{'none'});
end



%Across Network LASSO
for b=1:size(behavs,2)
disp(['*~*~*~*~*~*~*~*~*~*~ON BEHAV: ' behavs{b}])
Leo_RSFC_LASSO(behavs{b},'Visual','Fronto_Parietal',{'none'},{'gender'});

Leo_RSFC_LASSO(behavs{b},'Sensory_Somatomotor','Fronto_Parietal',{'none'},{'gender'});

Leo_RSFC_LASSO(behavs{b},'Sensory_Somatomotor','Visual',{'none'},{'gender'});

Leo_RSFC_LASSO(behavs{b},'Default_Mode','Visual',{'none'},{'gender'});

Leo_RSFC_LASSO_Output_Quartile(behavs{b},'Resonance','Control',{'gender'},{'none'});

Leo_RSFC_LASSO(behavs{b},'Resonance','Visual',{'none'},{'gender'});

Leo_RSFC_LASSO(behavs{b},'Default_Mode','Cingulo_Opercular',{'none'},{'gender'})

Leo_RSFC_LASSO(behavs{b},'Visual','Control',{'none'},{'gender'});
end



%Across Network LASSO
for b=1:size(behavs,2)
disp(['*~*~*~*~*~*~*~*~*~*~ON BEHAV: ' behavs{b}])
Leo_RSFC_LASSO(behavs{b},'Visual','Fronto_Parietal',{'none'},{'none'});

Leo_RSFC_LASSO(behavs{b},'Sensory_Somatomotor','Fronto_Parietal',{'none'},{'none'});

Leo_RSFC_LASSO(behavs{b},'Sensory_Somatomotor','Visual',{'none'},{'none'});

Leo_RSFC_LASSO(behavs{b},'Default_Mode','Visual',{'none'},{'none'});

Leo_RSFC_LASSO(behavs{b},'Resonance','Control',{'none'},{'none'});

Leo_RSFC_LASSO(behavs{b},'Resonance','Visual',{'none'},{'none'});

Leo_RSFC_LASSO(behavs{b},'Default_Mode','Cingulo_Opercular',{'none'},{'none'})

Leo_RSFC_LASSO(behavs{b},'Visual','Control',{'none'},{'none'});
end



networks={'Resonance','Control','Visual','Salience','Uncertain','Memory_Retrieval','Ventral_Attention','Cingulo_Opercular','Sensory_Somatomotor','Fronto_Parietal','Default_Mode', 'Dorsal_Attention','Subcortical','All'}; 
behavs={'Empathic_Concern' , 'Perspective_Taking','Personal_Distress' , 'Fantasizing','HSES','LSES','ASES'};

for n=1:size(networks, 1)
for b=1:size(behavs,2)
disp(['*~*~*~*~*~*~*~*~*~*~ON BEHAV: ' behavs{b}])
Leo_RSFC_LASSO(behavs{b},networks{n},[],{'avg_grayvol'},{'gender'});
Leo_RSFC_LASSO(behavs{b},networks{n},[],{'avg_grayvol'},{'none'});
end
Leo_RSFC_SVM('gender',networks{n},[],{'avg_grayvol'});

end

%%%%RUNNING ON JULY 30, 2018

behavs={'Empathic_Concern' , 'Perspective_Taking','Personal_Distress' , 'Fantasizing','HSES','LSES','ASES'};

for b=1:size(behavs,2)

    disp(['*~*~*~*~*~*~*~*~*~*~ON BEHAV: ' behavs{b}])
Leo_RSFC_LASSO(behavs{b},'Resonance','Default_Mode',{'gender'},{'none'});
% Leo_RSFC_SVM('gender','Resonance','Default_Mode',{'avg_grayvol'});


Leo_RSFC_LASSO(behavs{b},'Control','Sensory_Somatomotor',{'gender'},{'none'});
% Leo_RSFC_SVM('gender','Control','Sensory_Somatomotor',{'avg_grayvol'});


Leo_RSFC_LASSO(behavs{b},'Control','Fronto_Parietal',{'gender'},{'none'});
% Leo_RSFC_SVM('gender','Control','Fronto_Parietal',{'avg_grayvol'});


Leo_RSFC_LASSO(behavs{b},'Salience','Dorsal_Attention',{'gender'},{'none'});
% Leo_RSFC_SVM('gender','Salience','Dorsal_Attention',{'avg_grayvol'});

Leo_RSFC_LASSO(behavs{b},'Salience','Ventral_Attention',{'gender'},{'none'});
% Leo_RSFC_SVM('gender','Salience','Ventral_Attention',{'avg_grayvol'});

Leo_RSFC_LASSO(behavs{b},'Dorsal_Attention','Ventral_Attention',{'gender'},{'none'});
% Leo_RSFC_SVM('gender','Dorsal_Attention','Ventral_Attention',{'avg_grayvol'});

end


%%%%%%%%%



Leo_RSFC_SVM('gender','Resonance','Fronto_Parietal',{'avg_grayvol'});

Leo_RSFC_SVM('gender','Control','Fronto_Parietal',{'avg_grayvol'});

Leo_RSFC_SVM('gender','Resonance','Sensory_Somatomotor',{'avg_grayvol'});

Leo_RSFC_SVM('gender','Control','Sensory_Somatomotor',{'avg_grayvol'});

Leo_RSFC_SVM('gender','Resonance','Default_Mode',{'avg_grayvol'});

Leo_RSFC_SVM('gender','Control','Default_Mode',{'avg_grayvol'});

Leo_RSFC_SVM('gender','Visual','Cingulo_Opercular',{'avg_grayvol'});



Leo_RSFC_SVM('gender','Resonance','Fronto_Parietal',{'none'});

Leo_RSFC_SVM('gender','Control','Fronto_Parietal',{'none'});

Leo_RSFC_SVM('gender','Resonance','Sensory_Somatomotor',{'none'});

Leo_RSFC_SVM('gender','Control','Sensory_Somatomotor',{'none'});

Leo_RSFC_SVM('gender','Resonance','Default_Mode',{'none'});

Leo_RSFC_SVM('gender','Control','Default_Mode',{'none'});

Leo_RSFC_SVM('gender','Visual','Cingulo_Opercular',{'none'});



