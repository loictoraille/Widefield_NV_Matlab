function CropSelection(object,~)
set(object,'ForegroundColor',[0,0,1]);%Change button color to blue in the GUI

panel=guidata(gcbo);%handles of the graphical objects

waitforbuttonpress;

C1=get(panel.Axes1,'CurrentPoint');%Get coordinate of point where the mouseclick happens
finalrect=rbbox;%function to draw a rectangle box and wait for mouseclick
C2=get(panel.Axes1,'CurrentPoint');%Get coordinate of point where the mouseclick happens

% Convert to pixels if calibration is in µm
if strcmp(panel.calibunit.SelectedObject.String,'nm')
    size_pix = str2double(panel.pixelcalibvalue.String)/1000; % in µm
    C1_int = C1;clear C1;
    C2_int = C2;clear C2;
    C1 = round(C1_int/size_pix);
    C2 = round(C2_int/size_pix);
end

%Define box corners
x1=round(min(C1(1,1),C2(1,1)));
x2=round(max(C1(1,1),C2(1,1)));
y1=round(min(C1(1,2),C2(1,2)));
y2=round(max(C1(1,2),C2(1,2)));

%Avoid too small ROI
x1 = max(x1,1);
y1 = max(y1,1);
x2 = max(x2,x1+1);
y2 = max(y2,y1+1);

Crop = panel.Crop.Value;
if Crop
    oldx1 = str2num(panel.X1.String);
    oldy1 = str2num(panel.Y1.String);
    oldx2 = str2num(panel.X2.String);
    oldy2 = str2num(panel.Y2.String);  
    x1 = x1+oldx1;
    y1 = y1+oldy1;
    x2 = x2 + oldx1;
    y2 = y2 + oldy1;
end

panel.X1.String = num2str(x1);
panel.Y1.String = num2str(y1);
panel.X2.String = num2str(x2);
panel.Y2.String = num2str(y2);

panel.Crop.Value=1;
set(panel.Crop,'ForegroundColor',[0,0,1]);
CropOrUpdateImage();
UpdateWHValues()

set(object,'ForegroundColor',[0,0,0]);%Change button color to black
end