function [PixX,PixY] = RestrictPixPosToEdges(PixX,PixY)

panel=guidata(gcbo);

CalibUnit_str = panel.calibunit.SelectedObject.String;
PixelCalib_nm = str2double(panel.pixelcalibvalue.String);
size_pix = PixelCalib_nm/1000; % in µm

AllLim = {panel.Axes1.XLim(1),panel.Axes1.XLim(2),panel.Axes1.YLim(1),panel.Axes1.YLim(2)};

if strcmp(CalibUnit_str,'nm')
    for i=1:numel(AllLim)
        AllLim{i} = AllLim{i}/size_pix;
    end
end

if PixX<AllLim{1}
    PixX = ceil(AllLim{1});
end

if PixX>AllLim{2}
    PixX = floor(AllLim{2});
end

if PixY<AllLim{3}
    PixY = ceil(AllLim{3});
end

if PixY>AllLim{4}
    PixY = floor(AllLim{4});
end

end