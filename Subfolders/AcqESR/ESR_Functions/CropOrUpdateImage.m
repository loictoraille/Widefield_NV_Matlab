function CropOrUpdateImage()
global M Lum_Current

load([getPath('Param') 'FileInfo.mat'],'-mat','fname','pname');

if exist('Lum_Current','var')
    Image = Lum_Current;
else
    Image= M(:,:,1);
end

load([pname fname '.mat'],'AcqParameters');
[~,sizelevel] = size(AcqParameters.AOI.Width);
MaxLum = AcqParameters.MaxLum;

panel=guidata(gcbo);

if isfield(panel,'Crop')    
    Crop = panel.Crop.Value;    
    x1 = str2num(panel.X1.String);
    y1 = str2num(panel.Y1.String);
    x2 = str2num(panel.X2.String);
    y2 = str2num(panel.Y2.String);    
else
    Crop = 0;
end

if Crop
    ImageMatrix=Image(y1:y2,x1:x2);
    AOIParameters.AOI.Height = y2-y1+1;
    AOIParameters.AOI.Width = x2-x1+1;
    MatToPlot = M(y1:y2,x1:x2,:);
else
    ImageMatrix=Image;
    AOIParameters.AOI.Height = AcqParameters.AOI.Height(min(sizelevel,AcqParameters.AOILEVEL));
    AOIParameters.AOI.Width = AcqParameters.AOI.Width(min(sizelevel,AcqParameters.AOILEVEL));
    MatToPlot = M;
end

ax = panel.Axes1;
AOIParameters.PixelCalib_nm = str2double(panel.pixelcalibvalue.String);
AOIParameters.CalibUnit_str = panel.calibunit.SelectedObject.String;
PrintImage(ax,ImageMatrix,AOIParameters,MaxLum);
PixXStart = round(AOIParameters.AOI.Width/2);
PixYStart = round(AOIParameters.AOI.Height/2);
UpdatePixPos(PixXStart,PixYStart);
PrintESR(panel,MatToPlot);
panel.UserData.AOIParameters = AOIParameters;

end