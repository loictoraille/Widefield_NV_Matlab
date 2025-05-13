
% Define new area
if strcmp(CameraType,'Andor')
    maxLum = 65535;
elseif strcmp(CameraType,"heliCam")
	maxLum = 600; %TODO: "unhardcode" this, the variable ObjCamera.maxLum
else
    maxLum = 4095;
end

AOI = GetAOI();
ImageZero = zeros(AOI.Width,AOI.Height);

load([getPath('Param') 'AcqParameters.mat'],'-mat','AcqParameters');
[~,sizelevel] = size(AcqParameters.AOI.Width);

AOIParameters.AOI.Height = AcqParameters.AOI.Height(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.AOI.Width = AcqParameters.AOI.Width(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.PixelCalib_nm = AcqParameters.PixelCalib_nm;
AOIParameters.CalibUnit_str = AcqParameters.CalibUnit_str;

[x_axis,y_axis,x_label,y_label] = DefineAxes(AOIParameters);

haxes = findobj('tag','Axes_Camera');
axes(haxes);%Set current axes
handleImage = imagesc(x_axis,y_axis,ImageZero,[0,maxLum]);
set(haxes,'Tag','Axes_Camera');
axis('image'); 
xlabel(x_label);
ylabel(y_label);
c = colorbar;
c.Label.FontSize = 11;
c.Label.String = 'Photoluminescence';
%     if isprop(h.Axes_Camera,'Toolbar')
%         h.Axes_Camera.Toolbar.Visible = 'off';
%     end

