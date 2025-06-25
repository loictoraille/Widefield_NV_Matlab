
function CloseReq(hobject,eventdata)
global ObjCamera CameraType MW_Gen TestWithoutHardware NI_card SetupType

panel = guidata(gcf);

load([getPath('Param') 'AcqParameters.mat'],'-mat','AcqParameters');
ResetPiezo = AcqParameters.ResetPiezo;

if ~exist('TestWithoutHardware','var') || ~isscalar(TestWithoutHardware)
    TestWithoutHardware = 1;
end

btnStart= findobj('tag', 'startCTR'); % Trouver le bouton start s'il a un tag défini
if TestWithoutHardware~=1 && ~isempty(btnStart) && btnStart.Value == 1
        if isfield(btnStart.UserData, 'timer') && isvalid(btnStart.UserData.timer)
            stop(btnStart.UserData.timer);
            delete(btnStart.UserData.timer);
            btnStart.UserData = rmfield(btnStart.UserData, 'timer');
        end
        disp('End of continuous temperature reading');
end

h=guidata(gcbo);%handles of the graphical objects
if exist('h','var')
    h.stopcam.Value = 0;
end

if TestWithoutHardware~=1 && ~isempty(CameraType)
    EndAcqCamera();
    Exit_Camera();
end

if TestWithoutHardware~=1 && exist('MW_Gen','var') && any(isprop(MW_Gen,'Session'))
    try
        MW_Gen.Write('OUTP OFF'); %RF OFF
        if ismethod(MW_Gen, 'Close') % this function does not exist for visadev
            MW_Gen.Close();
        end
    catch
        disp('Connexion to RF Generator was not closed properly');
    end
end

if  TestWithoutHardware~=1 && strcmpi(SetupType,"CEA") && exist('NI_card','var') && any(isprop(NI_card,'Running')) && ~isempty(daqlist)
    try
        LaserOff(panel);
    catch
        disp('Unable to reach piezo hardware');
    end
end

if  TestWithoutHardware~=1 && ResetPiezo && exist('NI_card','var') && any(isprop(NI_card,'Running')) && ~isempty(daqlist)
    try
        write(NI_card,[0, 0, 0, 0]); % sets values back to 0 V
    catch
        disp('Unable to reach piezo hardware');
    end
end

if TestWithoutHardware~=1 && ~isempty(panel) && isfield(panel,'UserData') && isfield(panel.UserData,'Lakeshore') 
    Lakeshore = panel.UserData.Lakeshore;
    try
        flush(Lakeshore);
        clear Lakeshore
    catch
        disp('Unable to reach Lakeshore');
    end
end

if TestWithoutHardware~=1 && ~isempty(panel) && isfield(panel,'UserData') && isfield(panel.UserData,'Betsa')
    Betsa = panel.UserData.Betsa;
    writeline(Betsa, "RLY60"); % turns reflected light off
    flush(Betsa);
    clear Betsa
end

clear global

if isvalid(hobject) % Ensure the figure handle is still valid
    delete(hobject); % Deletes only the specific figure
    pause(0.1);      % Small delay to ensure deletion completes
    if isvalid(hobject)
        close(hobject, 'force'); % Force-close only this figure, if needed
    end
end

clearvars

end