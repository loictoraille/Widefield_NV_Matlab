function isPixInRange = CheckPixInRange(PixX,PixY)

panel=guidata(gcbo);

CalibUnit_str = panel.calibunit.SelectedObject.String;
PixelCalib_nm = str2double(panel.pixelcalibvalue.String);
size_pix = PixelCalib_nm/1000; % in µm

if strcmp(CalibUnit_str,'nm')
    ind_calib_nm = 1;
else
    ind_calib_nm = 0;
end

AllLim = {panel.Axes1.XLim(1),panel.Axes1.XLim(2),panel.Axes1.YLim(1),panel.Axes1.YLim(2)};

if ind_calib_nm
    for i=1:numel(AllLim)
        AllLim{i} = AllLim{i}/size_pix;
    end
else
end

%%Condition to be in panel image
if PixX>AllLim{1} && PixX<AllLim{2} && PixY>AllLim{3} && PixY<AllLim{4}
    isPixInRange = 1;    
else    
    isPixInRange = 0;
end

end