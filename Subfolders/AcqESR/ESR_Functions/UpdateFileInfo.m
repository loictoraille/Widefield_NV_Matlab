function UpdateFileInfo(ArgIn)
% Takes any number of parameters in [value,name] pair and updates FileInfo
% with them

for i=1:numel(ArgIn)
    Argi = ArgIn{i};
    eval([Argi{2} '= Argi{1};']);            
    save([getPath('Param') 'FileInfo.mat'],Argi{2},'-append');    
end

end