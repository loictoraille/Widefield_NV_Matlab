function nomSave = NameGen(pathIn,strIn,SaveValue)

PATH = pathIn;

if SaveValue
    nom_date = date;
    nomSave1 = [nom_date '-' strIn ];
    nomSave = [nomSave1 '-1'];
    ch = 1;

    while exist(fullfile(PATH,[nomSave '.mat']), 'file')==2
        ch = ch + 1;    
        nomSave = [nomSave1 '-' num2str(ch)];
    end
else
    nomSave = 'backup';
end

end