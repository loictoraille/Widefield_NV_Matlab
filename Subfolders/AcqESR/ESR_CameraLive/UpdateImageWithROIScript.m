
load([getPath('Param') 'AcqParameters.mat'],'-mat','AcqParameters');

MaxLum = AcqParameters.MaxLum;

% Define new area
AOI = GetAOI();
ImageZero = zeros(AOI.Width,AOI.Height);

[~,sizelevel] = size(AcqParameters.AOI.Width);

AOIParameters.AOI.Height = AcqParameters.AOI.Height(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.AOI.Width = AcqParameters.AOI.Width(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.PixelCalib_nm = AcqParameters.PixelCalib_nm;
AOIParameters.CalibUnit_str = AcqParameters.CalibUnit_str;

[x_axis,y_axis,x_label,y_label] = DefineAxes(AOIParameters);

haxes = findobj('tag','Axes_Camera');
axes(haxes);%Set current axes
handleImage = imagesc(x_axis,y_axis,ImageZero,[0,MaxLum]);
set(haxes,'Tag','Axes_Camera');
axis('image'); 
xlabel(x_label);
ylabel(y_label);
c = colorbar;
c.Label.FontSize = 11;
c.Label.String = 'Photoluminescence';
set(haxes,'Tag','Axes_Camera'); % Necessary to rewrite tag of axes after imagesc (I don't know why)
%     if isprop(h.Axes_Camera,'Toolbar')
%         h.Axes_Camera.Toolbar.Visible = 'off';
%     end

