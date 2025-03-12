
function FuncROI_define(h)
global ObjCamera CameraType handleImage

load([getPath('Param') 'AcqParameters.mat'],'-mat','AcqParameters');

set(h.roidef,'ForegroundColor',[0,0,1]);%Change button color to blue in the GUI

waitforbuttonpress;
C1=get(h.Axes_Camera,'CurrentPoint');%Get coordinate of point where the mouseclick happens
finalrect=rbbox;%function to draw a rectangle box and wait for mouseclick
C2=get(h.Axes_Camera,'CurrentPoint');%Get coordinate of point where the mouseclick happens

% Convert to pixels if calibration is in �m
if strcmp(h.calibunit.SelectedObject.String,'nm')
    size_pix = str2double(h.pixelcalibvalue.String)/1000; % in �m
    C1_int = C1;clear C1;
    C2_int = C2;clear C2;
    C1 = round(C1_int/size_pix);
    C2 = round(C2_int/size_pix);
end

%Define box corners
xmin=round(min(C1(1,1),C2(1,1)));
xmax=round(max(C1(1,1),C2(1,1)));
ymin=round(min(C1(1,2),C2(1,2)));
ymax=round(max(C1(1,2),C2(1,2)));

%Avoid too small ROI
xmin = max(xmin,1);
ymin = max(ymin,1);
xmax = max(xmax,xmin+1);
ymax = max(ymax,ymin+1);

%Define new ROI parameters
NewX=xmin;
NewY=ymin;
NewWidth=xmax-xmin+1;
NewHeight=ymax-ymin+1;

%Update ROI to the Camera
AOI = GetAOI();
if strcmp(CameraType,'uEye') 
    SetAOI(NewX+AOI.X,NewY+AOI.Y,max(16,NewWidth-mod(NewWidth,-4)),max(4,NewHeight-mod(NewHeight,-2)));
elseif strcmp(CameraType,'Andor')
    SetAOI(NewX+AOI.X,NewY+AOI.Y,NewWidth,NewHeight); 

elseif strcmp(CameraType,'heliCam')
	disp("warning (dev) : undefinded behavior in function FuncROI_define() for heliCam")
	   
elseif strcmp(CameraType,'Peak')
    if NewWidth < 256
        disp('Minimum Width with Peak Camera is 256 pixel');
    end
    SetAOI((NewX+AOI.X-mod((NewX+AOI.X),-4)),NewY+AOI.Y,max(256,NewWidth-mod(NewWidth,-2)),NewHeight);
end    
%%
set(h.roidef,'ForegroundColor',[0,0,0]);%Change button color to black
set(h.roidef,'Value',0);

UpdateImageWithROI;

FuncCameraRanges(h);%Update Ranges of the camera parameters/slider (they change with ROI)

end
