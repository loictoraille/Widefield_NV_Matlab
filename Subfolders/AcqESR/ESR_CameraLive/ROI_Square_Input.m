% Modify the size of the square, and update, also turns into a square if not squared already

function ROI_Square_Input(source,callbackdata)
global ObjCamera CameraType handleImage
h=guidata(gcbo);%handles of the graphical objects

UpdateAcqParam();
set(h.roisquaresize,'ForegroundColor',[0,1,0])

if ~h.acqcont.Value
    UpdateROI_Square_Input(h);
end

end