
function FuncROISquare_define(panel)
global ObjCamera CameraType handleImage

load([getPath('Param') 'AcqParameters.mat'],'-mat','AcqParameters');

ROISquareSize = AcqParameters.ROISquareSize;

set(panel.roisquare,'ForegroundColor',[0,1,0]);%Change button color to green in the GUI

% Create a square
square = rectangle('Position', [panel.Axes_Camera.XLim(2)/2-ROISquareSize/2, panel.Axes_Camera.YLim(2)/2-ROISquareSize/2, ROISquareSize, ROISquareSize], 'EdgeColor', 'red');

% Set the 'WindowButtonMotionFcn' callback function
set(gcf, 'WindowButtonMotionFcn', @updateSquarePosition);
set(gcf,'WindowButtonUpFcn', @mouseclick)

waitforbuttonpress;

% Callback function to update the square position
function updateSquarePosition(~, ~)
    panel = guidata(gcbo);
    % Get the current mouse cursor position    
    currentPoint=get(panel.Axes_Camera,'CurrentPoint');

    % Convert to pixels if calibration is in µm
    if strcmp(panel.calibunit.SelectedObject.String,'nm')
        size_pix = str2double(panel.pixelcalibvalue.String)/1000; % in µm
        currentPoint_int = currentPoint;clear currentPoint;
        currentPoint = round(currentPoint_int/size_pix);
    end
    
    x = currentPoint(1, 1);
    y = currentPoint(1, 2);
    
   % Update the position of the square
   if x - ROISquareSize/2 > panel.Axes_Camera.XLim(1) && x + ROISquareSize/2 < panel.Axes_Camera.XLim(2) && y - ROISquareSize/2 > panel.Axes_Camera.YLim(1) && y + ROISquareSize/2 < panel.Axes_Camera.YLim(2)
       set(square, 'Position', [x - floor(ROISquareSize/2), y - floor(ROISquareSize)/2, ROISquareSize, ROISquareSize]);
   end
   set(gcf,'WindowButtonUpFcn',@mouseclick)
   guidata(gcbo,panel);
end

function mouseclick(object,eventdata)
    panel = guidata(gcbo);
    
    C1=get(panel.Axes_Camera,'CurrentPoint');%Get coordinate of point where the mouseclick happens
    
    % Convert to pixels if calibration is in µm
    if strcmp(panel.calibunit.SelectedObject.String,'nm')
        size_pix = str2double(panel.pixelcalibvalue.String)/1000; % in µm
        C1_int = C1;clear C1;
        C1 = round(C1_int/size_pix);
    end
    
    %Define box corners
    CenterX = round(C1(1,1));
    CenterY = round(C1(1,2));
    
    AOI = GetAOI();
    
    CenterX = CenterX+AOI.X;
    CenterY = CenterY+AOI.Y;
    
    SetSquareFunction(panel,ROISquareSize,CenterX,CenterY)
    panel = guidata(gcbo);
    panel.roisquaresize.String = num2str(ROISquareSize);
    SaveAcqParameters({{ROISquareSize,'ROISquareSize'}});
    
    set(gcf,'WindowButtonMotionFcn','')
    set(gcf,'WindowButtonUpFcn','')
    set(panel.roisquare,'ForegroundColor',[0,0,0]);%Change button color to black
    set(panel.roisquare,'Value',0);
    guidata(gcbo,panel);
end


end