
function UpdateCalibUnit()
global CameraType handleImage

% AOIParameters.CalibUnit_str = panel.calibunit.SelectedObject.String;
% AOIParameters.PixelCalib_nm = str2double(panel.pixelcalibvalue.String);

load([getPath('Param') 'AcqParameters.mat'],'-mat','AcqParameters');
[~,sizelevel] = size(AcqParameters.AOI.Width);

AOIParameters.AOI.Height = AcqParameters.AOI.Height(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.AOI.Width = AcqParameters.AOI.Width(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.PixelCalib_nm = AcqParameters.PixelCalib_nm;
AOIParameters.CalibUnit_str = AcqParameters.CalibUnit_str;

MaxLum = AcqParameters.MaxLum;

haxes = findobj('tag','Axes_Camera');

[x_axis,y_axis,x_label,y_label] = DefineAxes(AOIParameters);

Data_Image = handleImage.CData;

axes(haxes);%Set current axes
handleImage = imagesc(x_axis,y_axis,Data_Image,[0,MaxLum]);
axis('image');
xlabel(x_label);
ylabel(y_label);
c = colorbar;
c.Label.FontSize = 11;
c.Label.String = 'Photoluminescence';
title(haxes,['Max pixel value = ' num2str(round(max(max(Data_Image))))]);
set(haxes,'Tag','Axes_Camera');

end
