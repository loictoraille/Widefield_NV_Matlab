
function SwitchPiezo(~,~)
global NI_card TestWithoutHardware SetupType

hpiezo=findobj('tag','switchpiezo');

load([getPath('Param') 'AcqParameters.mat'],'-mat','AcqParameters');
ResetPiezo = AcqParameters.ResetPiezo;

if hpiezo.Value == 0

if ResetPiezo && exist('NI_card','var') && any(isprop(NI_card,'Running')) && ~isempty(daqlist) && TestWithoutHardware~=1    
    write(NI_card,[0, 0, 0, 0]); % sets values back to 0 V
end
    
hpiezo.String = 'Piezo OFF';
hpiezo.ForegroundColor = [0,0,0];

if strcmpi(SetupType,"CEA")
    hlaser=findobj('tag','shutterlaser');
    hlaser.Value = 0;
    hlaser.ForegroundColor = [0,0,0];
elseif strcmpi(SetupType,"ENS1")
    hlight=findobj('tag','light');
    hlight.Value = 0;
    hlight.ForegroundColor = [0,0,0];
end

else
    panel = guidata(gcbo);
    InitPiezo(panel);
end
    
end