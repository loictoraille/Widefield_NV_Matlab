%%Elements of Tab2 (Camera)
load([getPath('Param') 'AcqParameters.mat']);

%% Pixel Calibration
bg = uibuttongroup('Parent',tab2,'units','normalized','Position',[0.6 0.15 0.15 0.11],'tag','calibunit','SelectionChangedFcn',@CalibUnit);              
              
uicontrol('Parent',bg,'Style','text','units','normalized','FontSize',20,'FontWeight','bold','HorizontalAlignment','center','Position',[0.01 0.65 0.98 0.3],'String','Pixel Calibration');              
r1 = uicontrol(bg,'Style','radiobutton','units','normalized','String','pixel','FontSize',14,'Position',[0.18 0.1 0.25 0.2]);              
r2 = uicontrol(bg,'Style','radiobutton','units','normalized', 'String','microns','FontSize',14,'Position',[0.5 0.1 0.35 0.2]);
              
if strcmp(AcqParameters.CalibUnit_str,'pixel')
   bg.SelectedObject = r1;
else
    bg.SelectedObject = r2;
end

uicontrol('Parent',bg,'Style','text','FontSize',14,'units','normalized','HorizontalAlignment','right','Position',[0.15 0.4 0.3 0.2],'String','1 pixel = ');
uicontrol('Parent',bg,'Style','edit','tag','pixelcalibvalue','FontSize',14,'units','normalized','Position',[0.45 0.4 0.2 0.2],'String',num2str(AcqParameters.PixelCalib_nm),'Callback',@CalibUnit);
uicontrol('Parent',bg,'Style','text','FontSize',14,'units','normalized','HorizontalAlignment','left','Position',[0.675 0.4 0.1 0.2],'String','nm');              

%%%%%%%%
%%Graphs
%%%%%%%%
%% Display live camera image
hp4 = uipanel('Parent',tab2,'Title','Camera','FontSize',12,'FontWeight','bold','BackgroundColor','white','Position',[0.01 0.28 .55 .7]);
axCam=axes('Parent',hp4,'tag','Axes_Camera','Position',[0.12 0.15  0.8 0.8]);

%%%%%%%%%
%% Buttons
%%%%%%%%%
%Start acquisition
AcqCont=uicontrol('Parent',tab2,'Style', 'togglebutton', 'String', 'ON','units','normalized','tag','acqcont', 'Position', [0.01 0.18 0.15 0.08],'FontSize',20,'ForegroundColor',[0,0,0],...
    'Value',0,'Callback',@AcqContinue);
%Stop acquisition
StopCam=uicontrol('Parent',tab2,'Style', 'togglebutton', 'String', 'OFF','units','normalized','tag','stopcam','Position', [0.2 0.18 0.15 0.08],'FontSize',20,'ForegroundColor',[0,0,0],...
    'Value',0);

%Exit Cam
% ExitCam=uicontrol('Parent',tab2,'Style', 'pushbutton', 'String', 'EXIT_Cam','units','normalized','tag','exitcam',...
%     'Position', [0.4 0.18 0.15 0.08],'FontSize',20,'ForegroundColor',[0,0,0],...
%     'Value',0,'Callback',@ExitCamCallback);

%Supress ROI
ROIOFF=uicontrol('Parent',tab2,'Style', 'togglebutton', 'String', 'ROI OFF','units','normalized','tag','roioff',...
    'Position', [0.01 0.02 0.15 0.08],'FontSize',20,'ForegroundColor',[0,0,0],...
    'Callback',@ROI_OFF,'Value',0);
%Define ROI
ROIDEF=uicontrol('Parent',tab2,'Style', 'togglebutton', 'String', 'ROI','units','normalized','tag','roidef',...
    'Position', [0.2 0.02 0.15 0.08],'FontSize',20,'ForegroundColor',[0,0,0],...
    'Callback',@ROI_define,'Value',0);
% ROI Back
ROIBack=uicontrol('Parent',tab2,'Style', 'togglebutton', 'String', 'ROI BACK','units','normalized','tag','roiback',...
    'Position', [0.4 0.02 0.15 0.08],'FontSize',20,'ForegroundColor',[0,0,0],...
    'Callback',@ROI_BACK,'Value',0);

% ROI Square
ROISquare = uicontrol('Parent', tab2, 'Style', 'togglebutton', 'String', 'SQUARE', 'units', 'normalized', 'tag', 'roisquare', ...
    'Position', [0.6 0.02 0.11 0.08], 'FontSize', 20, 'ForegroundColor', [0, 0, 0], 'Value', 0, 'HorizontalAlignment', 'center',...
    'Callback', @ROI_Square);

ROISquareInput = uicontrol('Parent', tab2, 'Style', 'edit', 'units', 'normalized', 'Position', [0.71 0.065 0.03 0.035], ...
    'String',num2str(AcqParameters.ROISquareSize),'ForegroundColor', [0, 0, 0],'FontSize',14,'tag','roisquaresize','Callback', @ROI_Square_Input);
ROISquareInputText = uicontrol('Parent',tab2,'Style','text','FontSize',14,'units','normalized','HorizontalAlignment','center','Position',[0.71 0.025 0.03 0.035],'String','pix');              


%Take Picture
Pic=uicontrol('Parent',tab2,'Style', 'togglebutton', 'String', 'Picture','units','normalized','tag','picacq',...
    'Position', [0.4 0.18 0.15 0.08],'FontSize',20,'ForegroundColor',[0,0,0],...
    'Callback',@Take_Photo,'Value',0);

%Save Camera Parameters
% SaveParam=uicontrol('Parent',tab2,'Style', 'pushbutton', 'String', 'Save Param','units','normalized','tag','saveparam',...
%     'Position', [0.6 0.02 0.15 0.08],'FontSize',20,'ForegroundColor',[0,0,0],...
%     'Callback',@SaveCamParam);
% 
% %Load Camera Parameters
% LoadParam=uicontrol('Parent',tab2,'Style', 'pushbutton', 'String', 'Load Param','units','normalized','tag','loadparam',...
%     'Position', [0.6 0.18 0.15 0.08],'FontSize',20,'ForegroundColor',[0,0,0],...
%     'Callback',@LoadCamParam);

%Automatic Exposure
uicontrol('Parent',tab2,'Style', 'togglebutton', 'String', 'Find Exposure','units','normalized','tag','findexposure',...
    'Position', [0.8 0.18 0.15 0.08],'FontSize',20,'ForegroundColor',[0,0,0],...
    'Callback',@FindExposure,'Value',0);

%Max Speed 
uicontrol('Parent',tab2,'Style', 'pushbutton', 'String', 'Maximize Speed','units','normalized','tag','maxspeed',...
    'Position', [0.8 0.02 0.15 0.08],'FontSize',20,'ForegroundColor',[0,0,0],...
    'Callback',@MaxSpeed);

%%%%%%%%%
%%Sliders
%%%%%%%%%
%% Exposure time
Sld_Exp=uicontrol('Parent',tab2,'Style','slider','Min',1,'Max',100,'Value',50,'tag','sldexp','units','normalized','Position', [0.73 0.75 0.2 0.05],'Callback',@SldExp);
expmin=uicontrol('Parent',tab2,'Style','text','string',1,'FontSize',10, 'tag','expmin','units','normalized','Position', [0.67 0.76 0.05 0.03],'HorizontalAlignment','right');
expmax=uicontrol('Parent',tab2,'Style','text','string',100,'FontSize',10,'tag','expmax','units','normalized','Position', [0.94 0.76 0.05 0.03],'HorizontalAlignment','left');
exptxt=uicontrol('Parent',tab2,'Style','text','string','Exposure','FontSize',15,'tag','exptext','units','normalized','Position', [0.73 0.82 0.2 0.03]);
lh=addlistener(Sld_Exp,'Value','PreSet',@ExpUpdate); % Listener to update slider value on the fly / camera exposure time is only updated when slider is released

exp_input=uicontrol('Parent',tab2,'Style','edit','tag','Input_Exp','FontSize',10,'units','normalized','Position',[0.817 0.715 0.025 0.025],'String',num2str(0.15),'Callback',@Input_Exposure);

%% Frame Rate
Sld_FrameRate=uicontrol('Parent',tab2,'Style','slider','Min',1,'Max',100,'Value',50,'tag','sldframe','units','normalized','Position', [0.73 0.55 0.2 0.05],'Callback',@SldFra);
framin=uicontrol('Parent',tab2,'Style','text','string',1,'FontSize',10,'tag','framin','units','normalized','Position', [0.67 0.56 0.05 0.03],'HorizontalAlignment','right');
framax=uicontrol('Parent',tab2,'Style','text','string',100,'FontSize',10,'tag','framax','units','normalized','Position', [0.94 0.56 0.05 0.03],'HorizontalAlignment','left');
fratxt=uicontrol('Parent',tab2,'Style','text','string','Frame Rate','FontSize',15,'tag','fratext','units','normalized','Position', [0.73 0.62 0.2 0.03]);
lh2=addlistener(Sld_FrameRate,'Value','PreSet',@FraUpdate);% Listener to update slider value on the fly / camera Frame Rate is only updated when slider is released

framerate_input=uicontrol('Parent',tab2,'Style','edit','tag','Input_FrameRate','FontSize',10,'units','normalized','Position',[0.817 0.515 0.025 0.025],'String',num2str(0.15),'Callback',@Input_FrameRate);


%% PixelClock
Sld_PixClock=uicontrol('Parent',tab2,'Style','slider','Min',1,'Max',100,'Value',50,'tag','sldpix','units','normalized','Position', [0.73 0.35 0.2 0.05],'Callback',@SldPix);
pixmin=uicontrol('Parent',tab2,'Style','text','string',1,'FontSize',10,'tag','pixmin','units','normalized','Position', [0.67 0.36 0.05 0.03],'HorizontalAlignment','right');
pixmax=uicontrol('Parent',tab2,'Style','text','string',100,'FontSize',10,'tag','pixmax','units','normalized','Position', [0.94 0.36 0.05 0.03],'HorizontalAlignment','left');
pixtxt=uicontrol('Parent',tab2,'Style','text','string','Pixel Clock','FontSize',15,'tag','pixtext','units','normalized','Position', [0.73 0.42 0.2 0.03]);
lh3=addlistener(Sld_PixClock,'Value','PreSet',@PixUpdate);% Listener to update slider value on the fly / camera PixelClock is only updated when slider is released

pixelclock_input=uicontrol('Parent',tab2,'Style','edit','tag','Input_PixelClock','FontSize',10,'units','normalized','Position',[0.817 0.315 0.025 0.025],'String',num2str(0.15),'Callback',@Input_PixelClock);


%% Piezo control
uicontrol('Parent',tab2,'Style','text','units','normalized','FontSize',16,'FontWeight','bold','HorizontalAlignment','left','Position',[0.593 0.75 0.1 0.03],'String','Piezo Control');
panel = uipanel('Parent',tab2,'Position',[0.58, 0.6, 0.1, 0.15]);

uicontrol('Parent', panel, 'Style', 'togglebutton','tag','switchpiezo','ForegroundColor',[0,0,0],'Value',0, 'String', 'Init Piezo', 'FontSize',12,'units','normalized',...
'Tooltip','Switch between zero-values and user-defined values, only if the reset values option is ticked','Position', [0.1, 0.77, 0.8, 0.2], 'Callback', @SwitchPiezo);

FS2 = 11;

editPosition = [0.1, 0.41, 0.25, 0.2];
uicontrol('Parent',panel, 'Style', 'text','FontSize',12,'units','normalized','FontSize',FS2, 'String', 'X', 'Position', editPosition + [0.08, 0.15, 0, 0],'HorizontalAlignment','left');
uicontrol('Parent',panel, 'Style', 'edit','FontSize',12,'units','normalized','FontSize',FS2, 'Position', editPosition + [0, 0, 0, 0], 'tag','piezoX', 'String',num2str(AcqParameters.PiezoX),'Callback',@UpdatePiezo);
uicontrol('Parent',panel, 'Style', 'text','FontSize',12,'units','normalized','FontSize',FS2, 'String', 'Y', 'Position', editPosition + [0.3, 0.15, 0, 0]);
uicontrol('Parent',panel, 'Style', 'edit','FontSize',12,'units','normalized','FontSize',FS2, 'Position', editPosition + [0.3, 0, 0, 0],'tag','piezoY',  'String',num2str(AcqParameters.PiezoY),'Callback',@UpdatePiezo);
uicontrol('Parent',panel, 'Style', 'text','FontSize',12,'units','normalized','FontSize',FS2, 'String', 'Z', 'Position', editPosition + [0.6, 0.15, 0, 0]);
uicontrol('Parent',panel, 'Style', 'edit','FontSize',12,'units','normalized','FontSize',FS2, 'Position', editPosition + [0.6, 0, 0, 0],'tag','piezoZ',  'String',num2str(AcqParameters.PiezoZ),'Callback',@UpdatePiezo);

PositionRow2 = [0.1, 0, 0.25, 0.2];
uicontrol('Parent',panel, 'Style', 'text','FontSize',12,'units','normalized','FontSize',FS2, 'String', 'Range', 'Position', PositionRow2 + [-0.02, 0.15, 0.05, 0],'HorizontalAlignment','center');
uicontrol('Parent',panel, 'Style', 'edit','FontSize',12,'units','normalized','FontSize',FS2, 'Position', PositionRow2 + [0, 0, 0, 0],'tag','piezoRange',  'String',num2str(AcqParameters.PiezoRange),'Callback',@UpdateAcqParam,'TooltipString','Range over which XY will be scanned for auto_alignment, Z range is doubled');
uicontrol('Parent',panel, 'Style', 'text','FontSize',12,'units','normalized','FontSize',FS2, 'String', 'Steps', 'Position', PositionRow2 + [0.3, 0.15, 0, 0],'HorizontalAlignment','center');
uicontrol('Parent',panel, 'Style', 'edit','FontSize',12,'units','normalized','FontSize',FS2, 'Position', PositionRow2 + [0.3, 0, 0, 0],'tag','piezoSteps',  'String',num2str(AcqParameters.PiezoSteps),'Callback',@UpdateAcqParam,'TooltipString','Number of steps taken inside the defined range during the auto_alignement, Z steps are doubled');
uicontrol('Parent',panel, 'Style', 'togglebutton','tag','light','FontSize',12,'units','normalized','FontSize',FS2, 'String', 'Light', 'Position', PositionRow2 + [0.56, 0.2, 0.05, 0],'HorizontalAlignment','center','Callback',@Light);
uicontrol('Parent',panel, 'Style', 'edit','FontSize',12,'units','normalized','FontSize',FS2, 'Position', PositionRow2 + [0.6, 0, 0, 0],'tag','piezoLightValue',  'String',num2str(AcqParameters.PiezoLight),'Callback',@UpdatePiezo,'TooltipString','Intensity of the light (only if it can be modified)');

%% Calib Piezo
calibPanelTitle = uicontrol('Parent',tab2,'Style','text','units','normalized','FontSize',16,'FontWeight','bold','HorizontalAlignment','left','Position', [0.593 0.562 0.1 0.03],'String','Calib (um/10V)');
calibPanel = uipanel('Parent',tab2,'Position',[0.61, 0.462, 0.05, 0.1]);

% Define font size
FS2 = 11;

% Define positions for text and edit boxes
calibTextPosition = [0, 0.63, 0.3, 0.3];
calibEditPosition = [0.3, 0.67, 0.5, 0.3];

% X Row
uicontrol('Parent',calibPanel, 'Style', 'text','FontSize',12,'units','normalized','FontSize',FS2, 'String', 'X', 'Position', calibTextPosition);
uicontrol('Parent',calibPanel, 'Style', 'edit','FontSize',12,'units','normalized','FontSize',FS2, 'Position', calibEditPosition, 'tag','calibPiezoX', 'String',num2str(AcqParameters.CalibPiezoX),'Callback',@UpdateAcqParam);

% Y Row
uicontrol('Parent',calibPanel, 'Style', 'text','FontSize',12,'units','normalized','FontSize',FS2, 'String', 'Y', 'Position', calibTextPosition - [0, 0.3, 0, 0]);
uicontrol('Parent',calibPanel, 'Style', 'edit','FontSize',12,'units','normalized','FontSize',FS2, 'Position', calibEditPosition - [0, 0.3, 0, 0], 'tag','calibPiezoY', 'String',num2str(AcqParameters.CalibPiezoY),'Callback',@UpdateAcqParam);

% Z Row
uicontrol('Parent',calibPanel, 'Style', 'text','FontSize',12,'units','normalized','FontSize',FS2, 'String', 'Z', 'Position', calibTextPosition - [0, 0.6, 0, 0]);
uicontrol('Parent',calibPanel, 'Style', 'edit','FontSize',12,'units','normalized','FontSize',FS2, 'Position', calibEditPosition - [0, 0.6, 0, 0], 'tag','calibPiezoZ', 'String',num2str(AcqParameters.CalibPiezoZ),'Callback',@UpdateAcqParam);

uicontrol('Parent',tab2,'Style', 'checkbox', 'String', 'Reset values upon exit','units','normalized','tag','ResetPiezo','Position', [0.586 0.427 0.1 0.025],'FontSize',11,'Value',AcqParameters.ResetPiezo,'Callback',@UpdateAcqParam,'TooltipString','Reset all four NI card outputs to 0V when closing the program window');

%% Text

uicontrol('Parent',tab2,'Style','text','tag','cameratype','units','normalized','FontSize',16,'FontWeight','bold','HorizontalAlignment','right','Position',[0.66 0.93 0.2 0.03],'String','Camera type');

uicontrol('Parent',tab2,'Style', 'text', 'String', sprintf('TEST WITHOUT\n  HARDWARE'),'ForegroundColor','red','units','normalized','tag','testwohar2','Position',...
    [0.795 0.87 0.085 0.055],'FontSize',15,'FontWeight','bold','VISIBLE',valuetestwohar);


%% Shutter laser

uicontrol('Parent', tab2, 'Style', 'togglebutton','tag','shutterlaser','ForegroundColor',[0,0,0],'Value',0, 'String', 'Laser', 'FontSize',14,'units','normalized',...
'Tooltip','Switches the shutter controlling the laser excitation, if it exists','Position', [0.608, 0.83, 0.04, 0.04], 'Callback', @SwitchShutterLaser);


%% Autofocus Piezo

uicontrol('Parent', tab2, 'Style', 'togglebutton','tag','autofocuspiezo','ForegroundColor',[0,0,0],'Value',0, 'String', 'Autofocus piezo z', 'FontSize',14,'units','normalized',...
'Tooltip','Starts the autofocus piezo z procedure, if piezo are connected','Position', [0.58, 0.35, 0.1, 0.04], 'Callback', @AutofocusPiezo);

%% Shutter Raman Betsa

uicontrol('Parent', tab2, 'Style', 'togglebutton','tag','shutterBetsa','ForegroundColor',[0,0,0],'Value',0, 'String', 'Shutter Betsa', 'FontSize',14,'units','normalized',...
'Tooltip','Switches the shutter from Betsa between Raman measure and light','Position', [0.588, 0.88, 0.08, 0.04], 'Callback', @SwitchShutterBetsa);

