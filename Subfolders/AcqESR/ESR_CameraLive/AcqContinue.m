%Continuous acquisition with the camera

function AcqContinue(~,~)
global ObjCamera CameraType handleImage

h=guidata(gcbo);

FuncAcqContinue(h);

guidata(gcbo,h);
end
    
    


        
    