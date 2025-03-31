
function UpdateROI_Square_Input(h)
global ObjCamera CameraType handleImage

set(h.roisquaresize,'ForegroundColor',[0,0,1]);%Change button color to blue in the GUI

load([getPath('Param') 'AcqParameters.mat'],'-mat','AcqParameters');
[~,sizelevel] = size(AcqParameters.AOI.Width);

ROISquareSize = AcqParameters.ROISquareSize;

X = AcqParameters.AOI.X(min(sizelevel,AcqParameters.AOILEVEL));
Y = AcqParameters.AOI.Y(min(sizelevel,AcqParameters.AOILEVEL));
Width = AcqParameters.AOI.Width(min(sizelevel,AcqParameters.AOILEVEL));
Height = AcqParameters.AOI.Height(min(sizelevel,AcqParameters.AOILEVEL));

%Define new ROI parameters
CenterX = X+floor(Width/2);
CenterY = Y+floor(Height/2);

SetSquareFunction(h,ROISquareSize,CenterX,CenterY)

h.roisquaresize.String = num2str(ROISquareSize);
SaveAcqParameters({{ROISquareSize,'ROISquareSize'}});

set(h.roisquaresize,'ForegroundColor',[0,0,0]);%Change button color to black

end