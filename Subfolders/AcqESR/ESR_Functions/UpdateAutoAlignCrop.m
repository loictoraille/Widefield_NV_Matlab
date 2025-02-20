function UpdateAutoAlignCrop(hobject,eventdata)

panel=guidata(gcbo);

AutoAlignCrop = panel.AutoAlignCrop.Value;
if AutoAlignCrop == 1
    panel.AutoAlignCam.Value = 0;
    panel.AutoAlignPiezo.Value = 0;
end

UpdateAcqParam(hobject,eventdata);

end