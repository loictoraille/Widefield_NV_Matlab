function [nomSave, num] = NameGen(pathIn,strIn,SaveValue)

PATH = pathIn;

if SaveValue
    nomSave = strIn;
    nomSave = [nomSave '-001'];
    ch = 1;

    while exist(fullfile(PATH,[nomSave '.mat']), 'file')==2
        ch = ch + 1;    
        nomSave = [strIn '-' sprintf('%03d', ch)]; % Zero-padded number
    end

    num = ch;
else
    nomSave = 'backup';
    num = 0;
end

end