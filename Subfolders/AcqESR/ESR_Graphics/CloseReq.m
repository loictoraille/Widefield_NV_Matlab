
function CloseReq(hobject,eventdata)
global ObjCamera CameraType smb TestWithoutHardware NI_card

h=guidata(gcbo);%handles of the graphical objects
if exist('h','var')
    h.stopcam.Value = 0;
end

if ~isempty(CameraType) && TestWithoutHardware~=1
    EndAcqCamera();
    Exit_Camera();
end

if exist('smb','var') && any(isprop(smb,'Session')) && TestWithoutHardware~=1
    smb.Write('OUTP OFF');%RF OFF
    smb.Close();
end

if exist('NI_card','var') && any(isprop(NI_card,'Running')) && ~isempty(daqlist) && TestWithoutHardware~=1    
    write(NI_card,[0, 0, 0, 0]); % sets values back to 0 V
end

clear global ObjCamera
clear global CameraType
clear global smb
clear global NI_card
clearvars
delete(gcf)

end