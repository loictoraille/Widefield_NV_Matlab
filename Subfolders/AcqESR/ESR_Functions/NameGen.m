function nomSave = NameGen(pathIn,strIn,SaveValue)

PATH = pathIn;

if SaveValue
    nomSave = strIn;
    nomSave = [nomSave '-001'];
    ch = 1;

    while exist(fullfile(PATH,[nomSave '.mat']), 'file')==2
        ch = ch + 1;    
        nomSave = [nomSave '-' sprintf('%03d', ch)]; % Zero-padded number
    end
else
    nomSave = 'backup';
end

end