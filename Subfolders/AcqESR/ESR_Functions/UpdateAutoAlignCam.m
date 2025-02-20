function UpdateAutoAlignCam(hobject,eventdata)

panel=guidata(gcbo);

AutoAlignCam = panel.AutoAlignCam.Value;
if AutoAlignCam == 1
    panel.AutoAlignCrop.Value = 0;
    panel.AutoAlignPiezo.Value = 0;
end

UpdateAcqParam(hobject,eventdata);

end