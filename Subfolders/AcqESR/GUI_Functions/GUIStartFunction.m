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

startTime = datetime('now'); % Capture l'heure de départ

while i_scan <= TotalScan
    disp(['Starting acquisition number ' num2str(i_scan) ' / ' num2str(TotalScan)]);
    StartFunction(i_scan);
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

end