function GUIStartFunction(hobject,eventdata)
global M ObjCamera CameraType handleImage MW_Gen TestWithoutHardware RF_Address Lum_Current

set(hobject,'ForegroundColor',[0,0,1]);
stop_tag = findobj('tag','stop');

load([getPath('Param') 'AcqParameters.mat'],'AcqParameters');

i_scan = 1;

if AcqParameters.RepeatScan > 1
    TotalScan = AcqParameters.RepeatScan;
else
    TotalScan = 1;
end

panel = guidata(gcbo);
h_betsa=findobj('tag','shutterBetsa');

if isfield(panel,'UserData') && ~isempty(panel.UserData) && isfield(panel.UserData,'Betsa')
    Betsa = panel.UserData.Betsa;
    Init_betsa_value = h_betsa.Value;
end

ini_light_state = panel.light.Value;
ini_laser_state = panel.shutterlaser.Value;

startTime = datetime('now'); % Capture l'heure de départ

Lum_Initial = [];
Lum_Initial_LaserOff = [];

BuildName = NameGen(AcqParameters.Data_Path,panel.FileNamePrefix.String);
SaveAcqParameters({{BuildName,'BuildName'}});
nomSave = BuildName; nomSave_init = nomSave;
PrintName = GetSaveName(BuildName,panel.Save.Value);
panel.nameFile.String = PrintName;
time_one_scan = 0; % initialization

if AcqParameters.Save == 1 && TotalScan > 1
    name_diary_init = DiaryName(AcqParameters.Data_Path, nomSave_init, panel.FileNamePrefixChoice.SelectedObject.String,TotalScan);
    diary(name_diary_init);  % Starts to save
    disp('Sarting log of command window')  % Toute sortie affichée ici sera enregistrée
end

if AcqParameters.Save == 0 && TotalScan > 1
    name_diary_init = [AcqParameters.Data_Path 'backup'];
end

while i_scan <= TotalScan

    disp(['Starting acquisition number ' num2str(i_scan) ' / ' num2str(TotalScan)]);
    disp(['Current Date and Time: ', datestr(datetime('now'))]);
    if AcqParameters.RepeatScan > 1 && i_scan ~= 1
        BuildName = GenNextFileName(BuildName,panel.FileNamePrefixChoice.SelectedObject.String,AcqParameters.RepeatScan); % so that the date change does not change the name
        SaveAcqParameters({{BuildName,'BuildName'}});
        nomSave = BuildName;
        PrintName = GetSaveName(BuildName,panel.Save.Value);
        panel.nameFile.String = PrintName;
    end
    tic
    [Lum_Initial,Lum_Initial_LaserOff] = StartFunction(i_scan, Lum_Initial, Lum_Initial_LaserOff, nomSave, time_one_scan);
    measured_time_scan = toc;
    if measured_time_scan > time_one_scan 
        time_one_scan = measured_time_scan;
    end
    if stop_tag.Value == 1 % Check STOP Button
        break;
    end
    i_scan = i_scan + 1;
end

endTime = datetime('now'); % Capture l'heure de fin
elapsedTime = endTime - startTime; % Calcule la durée écoulée

if AcqParameters.RepeatScan > 1
    disp(['Full acquisition lasted: ' formatDurationDate(elapsedTime)]);
    current_string = panel.AcqTime.String;
    nRows = size(current_string,1);
    if nRows > 1
        current_string = current_string(1,:);
    end
    panel.AcqTime.String = [current_string newline 'Total Acquisition time = ' formatDurationDate(elapsedTime)];
    diary off
    % update log file name
    newLogName = DiaryName(AcqParameters.Data_Path, nomSave_init, panel.FileNamePrefixChoice.SelectedObject.String,i_scan-1); 
    if (exist(name_diary_init,'file') == 2) && (strcmp(name_diary_init,newLogName) ~= 1)
        movefile(name_diary_init, newLogName);
    end
end

set(hobject,'ForegroundColor',[1,0,0]);
set(hobject,'Value',0);

set(stop_tag,'ForegroundColor',[1,0,0]);
set(stop_tag,'Value',0);

% restore inital switch parameters

if isfield(panel,'UserData') && ~isempty(panel.UserData) && isfield(panel.UserData,'Betsa')
    if Init_betsa_value == 1
        h_betsa.Value = 1;
        h_betsa.ForegroundColor = [0,0,1];
        writeline(Betsa, "RLY50"); % switches shutter toward light mode
    else
        h_betsa.Value = 0;
        h_betsa.ForegroundColor = [0,0,0];
        writeline(Betsa, "RLY51"); % switches shutter toward Raman mode
    end
else
    h_betsa.Value = 0;
end

if ini_light_state
    panel.light.Value = 1;
    panel.light.ForegroundColor = [0 0 1];
else
    panel.light.Value = 0;
    panel.light.ForegroundColor = [0 0 0];
end

if ini_laser_state
    panel.shutterlaser.Value = 1;
    panel.shutterlaser.ForegroundColor = [0 0 1];
else
    panel.shutterlaser.Value = 0;
    panel.shutterlaser.ForegroundColor = [0 0 0];
end
    
Tension4 = Smart_PZ_Light_Laser_Write(panel);

end