function SaveAcqParameters(ArgIn)
% Takes any number of parameters in {{value,name}} pair and updates AcqParameters with them

load([getPath('Param') 'AcqParameters.mat'],'AcqParameters');

for i=1:numel(ArgIn)
    Argi = ArgIn{i};
    eval(['AcqParameters.' Argi{2} '= Argi{1};']);      
end      

save([getPath('Param') 'AcqParameters.mat'],'AcqParameters','-append');   

end