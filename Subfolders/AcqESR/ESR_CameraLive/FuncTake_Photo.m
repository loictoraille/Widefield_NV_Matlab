
function FuncTake_Photo(h)
global ObjCamera CameraType handleImage
set(h.picacq,'ForegroundColor',[0,0,1]);%Change button color to blue in the GUI

load([getPath('Param') 'AcqParameters.mat'],'AcqParameters');
Data_Path = AcqParameters.Data_Path;

haxes = findobj('tag','Axes_Camera');

MaxLum = str2double(h.MaxLum.String);

[Picture,ISize,AOI] = PrepareCamera();

Picture=TakeCameraImage(ISize,AOI);
nomSave1 = [Data_Path date '-Photo'];
nomSave = [nomSave1 '-1'];
ch = 1;
while exist(fullfile([nomSave '.mat']), 'file')==2
    ch = ch + 1;
    nomSave = [nomSave1 '-' num2str(ch)];    
end

load([getPath('Param') 'AcqParameters.mat'],'AcqParameters');
[~,sizelevel] = size(AcqParameters.AOI.Width);

AOIParameters.AOI.Height = AcqParameters.AOI.Height(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.AOI.Width = AcqParameters.AOI.Width(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.PixelCalib_nm = AcqParameters.PixelCalib_nm;
AOIParameters.CalibUnit_str = AcqParameters.CalibUnit_str;

[x_axis,y_axis,x_label,y_label] = DefineAxes(AOIParameters);

figPic = figure('Name',nomSave);
imagesc(x_axis,y_axis,Picture,[0,MaxLum])
axis('image');
title({'Intensité lumineuse (a.u.)'});
ax = gca;
ax.XAxisLocation = 'bottom';
ax.TickDir = 'out';
xlabel(x_label);
ylabel(y_label);  
c = colorbar;
c.FontSize = 10.5; 
set(haxes,'Tag','Axes_Camera'); % Necessary to rewrite tag of axes after imagesc (I don't know why)
save(nomSave,'Picture');
saveas(figPic,[nomSave '.jpg'],'jpeg');
figure(1)


EndAcqCamera();
set(h.picacq,'ForegroundColor',[0,0,0]);%Change button color to black
set(h.picacq,'Value',0);


end
