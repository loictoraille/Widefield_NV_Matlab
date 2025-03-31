function GUIStartFunction(hobject,eventdata)
global M ObjCamera CameraType handleImage smb TestWithoutHardware RF_Address Lum_Current

set(hobject,'ForegroundColor',[0,1,0]);
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

nomSave = NameGen(AcqParameters.Data_Path,AcqParameters.FileNamePrefix,AcqParameters.Save);

while i_scan <= TotalScan
    disp(['Starting acquisition number ' num2str(i_scan) ' / ' num2str(TotalScan)]);
    disp(['Current Date and Time: ', datestr(datetime('now'))]);
    [Lum_Initial,Lum_Initial_LaserOff] = StartFunction(i_scan, Lum_Initial, Lum_Initial_LaserOff, nomSave);
    i_scan = i_scan + 1;
    if stop_tag.Value == 1 % Check STOP Button
        break;
    end
end

endTime = datetime('now'); % Capture l'heure de fin
elapsedTime = endTime - startTime; % Calcule la durée écoulée

if AcqParameters.RepeatScan > 1
    % Convertir en heures, minutes, secondes
    [h, m, s] = hms(elapsedTime);
    disp(['Full acquisition lasted: ', num2str(floor(h)), 'h ', num2str(floor(m)), 'm ', num2str(round(s)), 's']);
end

set(hobject,'ForegroundColor',[1,0,0]);
set(hobject,'Value',0);

set(stop_tag,'ForegroundColor',[1,0,0]);
set(stop_tag,'Value',0);

% restore inital switch parameters

if isfield(panel,'UserData') && ~isempty(panel.UserData) && isfield(panel.UserData,'Betsa')
    if Init_betsa_value == 1
        h_betsa.Value = 1;
        h_betsa.ForegroundColor = [0,1,0];
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
    panel.light.ForegroundColor = [0 1 0];
else
    panel.light.Value = 0;
    panel.light.ForegroundColor = [0 0 0];
end

if ini_laser_state
    panel.shutterlaser.Value = 1;
    panel.shutterlaser.ForegroundColor = [0 1 0];
else
    panel.shutterlaser.Value = 0;
    panel.shutterlaser.ForegroundColor = [0 0 0];
end
    
Tension4 = Smart_PZ_Light_Laser_Write(panel);

end