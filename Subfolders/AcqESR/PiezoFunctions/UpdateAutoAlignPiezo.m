function UpdateAutoAlignPiezo(hobject,eventdata)

panel=guidata(gcbo);

AutoAlignPiezo = panel.AutoAlignPiezo.Value;
if AutoAlignPiezo == 1
    panel.AutoAlignCam.Value = 0;
    panel.AutoAlignCrop.Value = 0;
end

UpdateAcqParam(hobject,eventdata);

end