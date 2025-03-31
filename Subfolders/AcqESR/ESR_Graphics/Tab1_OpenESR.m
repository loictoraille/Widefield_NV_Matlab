%%Elements of Tab1 (ESR) 


%%%%%%%%
%%Additional parameters
%%%%%%%%

uicontrol('Parent',tab1,'Style', 'checkbox', 'String', 'Display light','units','normalized','tag','DisplayLight',...
    'Position', [0.45 0.825 0.065 0.025],'FontSize',10,'Value',AcqParameters.DisplayLight,'Callback',@DisplayLightOpenESR,'Tooltip','If available, displays the image with light and laser instead of only with laser');

%%%%%%%%

%%%%%%%%
%%Graphs
%%%%%%%%
%Image taken at cycle start
hp = uipanel('Parent',tab1,'Title','Sample Image','FontSize',12,'FontWeight','bold',...
    'BackgroundColor','white','Position',[0.05 0.28 .4 .6]);
ax=axes('Parent',hp,'tag','Axes1','Position',[0.12 0.15  0.8 0.8]);
%ESR on one pixel
hp2 = uipanel('Parent',tab1,'Title','ESR One Pixel','FontSize',12,'FontWeight','bold',...
    'BackgroundColor','white','Position',[0.5 0.5 .5 .5]);
ax2=axes('Parent',hp2,'tag','Axes2','Position',[0.12 0.15  0.8 0.8]);
l21=line('tag','l21');
xlabel('Microwave Frequency (GHz)');
ylabel('Normalized Luminescence (a.u.)');
%ESR with binning
hp3 = uipanel('Parent',tab1,'Title','ESR with Binning','FontSize',12,'FontWeight','bold',...
    'BackgroundColor','white','Position',[0.5 0 .5 .5]);
ax3=axes('Parent',hp3,'tag','Axes3','Position',[0.12 0.15  0.8 0.8]);
l31=line('tag','l31');
xlabel('Microwave Frequency (GHz)');
ylabel('Normalized Luminescence (a.u.)');


%%%%%%%%%
%%%%%Crop
%%%%%%%%%
StartingX1 = 26;
StartingY1 = 26;
StartingX2 = 50;
StartingY2 = 50;
StartingX0 = 38;
StartingY0 = 38;
StartingW = 25;
StartingH = 25;

%To turn the crop on or off
CropButton=uicontrol('Parent',tab1,'Style', 'togglebutton', 'String', 'Crop','units','normalized','tag','Crop',...
    'Position', [0.15 0.915 0.05 0.05],'FontSize',18,'ForegroundColor',[1,0,0],'Callback',@CropFunction);
%To select the cropping coord by value
cpanel=uipanel('Parent',tab1,'Position',[0.2025 0.8925 0.05 0.095]);
uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.205 0.965 0.02 0.02],'String','x1');
uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.23 0.965 0.02 0.02],'String','y1');
uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.205 0.915 0.02 0.02],'String','x2');
uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.23 0.915 0.02 0.02],'String','y2');
x1_handle=uicontrol('Parent',tab1,'Style','edit','tag','X1','units','normalized','Position',[0.205 0.945 0.02 0.02],'String',num2str(StartingX1),'Callback',@InputCrop1);
y1_handle=uicontrol('Parent',tab1,'Style','edit','tag','Y1','units','normalized','Position',[0.23 0.945 0.02 0.02],'String',num2str(StartingY1),'Callback',@InputCrop1);
x2_handle=uicontrol('Parent',tab1,'Style','edit','tag','X2','units','normalized','Position',[0.205 0.895 0.02 0.02],'String',num2str(StartingX2),'Callback',@InputCrop1);
y2_handle=uicontrol('Parent',tab1,'Style','edit','tag','Y2','units','normalized','Position',[0.23 0.895 0.02 0.02],'String',num2str(StartingY2),'Callback',@InputCrop1);
%To select the cropping coord using center and h,w
cpanel2=uipanel('Parent',tab1,'Position',[0.2575 0.8925 0.05 0.095]);
uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.26 0.965 0.02 0.02],'String','x0');
uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.285 0.965 0.02 0.02],'String','y0');
uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.26 0.915 0.02 0.02],'String','w');
uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.285 0.915 0.02 0.02],'String','h');
x0_handle=uicontrol('Parent',tab1,'Style','edit','tag','X0','units','normalized','Position',[0.26 0.945 0.02 0.02],'String',num2str(StartingX0),'Callback',@InputCrop2);
y0_handle=uicontrol('Parent',tab1,'Style','edit','tag','Y0','units','normalized','Position',[0.285 0.945 0.02 0.02],'String',num2str(StartingY0),'Callback',@InputCrop2);
w_handle=uicontrol('Parent',tab1,'Style','edit','tag','W','units','normalized','Position',[0.26 0.895 0.02 0.02],'String',num2str(StartingW),'Callback',@InputCrop2);
h_handle=uicontrol('Parent',tab1,'Style','edit','tag','H','units','normalized','Position',[0.285 0.895 0.02 0.02],'String',num2str(StartingH),'Callback',@InputCrop2);
%To select the crop area
uicontrol('Parent',tab1,'Style', 'togglebutton', 'String', 'Select','units','normalized','tag','CropSelection',...
    'Position', [0.31 0.94 0.07 0.05],'FontSize',18,'ForegroundColor',[1,0,0],'Callback',@CropSelection);
%To force a square shape centered on the center
uicontrol('Parent',tab1,'Style', 'pushbutton', 'String', 'Square','units','normalized','tag','StoreParam',...
    'Position', [0.31 0.89 0.07 0.05],'FontSize',18,'Callback',@ForceSquareFunction);

%%%%%%%%%
%%Buttons
%%%%%%%%%

%To open file
OpenFileButton=uicontrol('Parent',tab1,'Style', 'pushbutton', 'String', 'Open File','units','normalized','tag','OpenFile',...
    'Position',  [0.025 0.935 0.1 0.05],'FontSize',25,'FontWeight','bold','Callback',@OpenFileFunction);
%To switch file
PrevFileButton=uicontrol('Parent',tab1,'Style', 'pushbutton', 'String', 'prev','units','normalized','tag','PrevFile',...
    'Position',  [0.032 0.89 0.04 0.04],'FontSize',18,'FontWeight','bold','Callback',@PrevFileFunction);
NextFileButton=uicontrol('Parent',tab1,'Style', 'pushbutton', 'String', 'next','units','normalized','tag','NextFile',...
    'Position',  [0.077 0.89 0.04 0.04],'FontSize',18,'FontWeight','bold','Callback',@NextFileFunction);
%To compare spectra at 2 positions
CompButton=uicontrol('Parent',tab1,'Style', 'togglebutton', 'String', 'Compare','units','normalized','tag','comp',...
    'Position', [0.35 0.16 0.15 0.08],'FontSize',20,'ForegroundColor',[1,0,0],...
    'Value',0,'Callback',@CompareFunction);
%To change selected pixel
PixelButton=uicontrol('Parent',tab1,'Style', 'togglebutton', 'String', 'Pix','units','normalized','tag','Pix',...
    'Position', [0.35 0 0.15 0.08],'FontSize',20,'ForegroundColor',[1,0,0],...
    'Callback',@PixelFunction);
%To print cursors
CursorButton=uicontrol('Parent',tab1,'Style', 'togglebutton', 'String', 'Cursors','units','normalized','tag','Cursor',...
    'Position', [0.28 0 0.07 0.08],'FontSize',20,'ForegroundColor',[1,0,0],...
    'Callback',@CursorFunction);
%To fit
FitButton=uicontrol('Parent',tab1,'Style', 'togglebutton', 'String', 'Fit','units','normalized','tag','Fit',...
    'Position', [0.35 0.08 0.15 0.08],'FontSize',20,'ForegroundColor',[1,0,0],...
    'Callback',@FitFunction);
%To store fit pix results as pstart
StoreFitPixButton=uicontrol('Parent',tab1,'Style', 'pushbutton', 'String', 'StoreFitPix','units','normalized','tag','StoreFitPix',...
    'Position', [0.28 0.12 0.07 0.04],'FontSize',16,'Callback',@StoreFitPixFunction);
%To store fit bin results as pstart
StoreFitBinButton=uicontrol('Parent',tab1,'Style', 'pushbutton', 'String', 'StoreFitBin','units','normalized','tag','StoreFitBin',...
    'Position', [0.28 0.08 0.07 0.04],'FontSize',16,'Callback',@StoreFitBinFunction);
%To use pstart or not
UsePstartCheckBox=uicontrol('Parent',tab1,'Style', 'checkbox', 'String', 'Use Input Pstart','units','normalized','tag','UsePstart',...
    'Position', [0.35 0.24 0.1 0.04],'FontSize',10,'Value',0,'Callback',@UpdateFit);
%To start full fit
FullFitButton=uicontrol('Parent',tab1,'Style', 'pushbutton', 'String', 'FullFit','units','normalized','tag','FullFit',...
    'Position',  [0.41 0.89 0.06 0.05],'FontSize',20,'ForegroundColor',[0,0,1],'Callback',@FullFitFunction);
%To delete extreme frequency points
DelExButton=uicontrol('Parent',tab1,'Style', 'pushbutton', 'String', 'DelEx','units','normalized','tag','DelEx',...
    'Position',  [0.41 0.94 0.06 0.05],'FontSize',20,'ForegroundColor',[0,0,1],'Tooltip','Deletes first and last frequency points and saves it into a new file which is then loaded','Callback',@DelExFunction);
%To use AutoBase or not
AutoBaseCheckBox=uicontrol('Parent',tab1,'Style', 'checkbox', 'String', 'AutoBase','units','normalized','tag','AutoBase',...
    'Position', [0.44 0.24 0.05 0.04],'FontSize',10,'Tooltip',['The AutoBase proceeds with a lot of sgolayfilt, which takes a long' ...
     'time, for generally little to no value in the result if the spectrum is flat. Only use if really needed.'],'Value',0,'Callback',@UpdateFit);
%To export shown ESR
ExportESRButton=uicontrol('Parent',tab1,'Style', 'pushbutton', 'String', 'ExportESR','units','normalized','tag','ExportESR',...
    'Position', [0.2 0 0.08 0.08],'FontSize',20,'Callback',@ExportESRFunction);
%To compress loaded file
CompressButton=uicontrol('Parent',tab1,'Style', 'pushbutton', 'String', 'Compress','units','normalized','tag','Compress',...
    'Position', [0.2 0.08 0.08 0.04],'FontSize',16,'Callback',@CompressFunction, 'Tooltip', 'Resave the file in compressed format (useful only if it was saved in fast&heavy format)');

%%%%%%%%%%%%
%%Text boxes
%%%%%%%%%%%%
StartingX = 1;
StartingY = 1;
StartingBin = 5;

%Pixels chosen for the printed ESR
uicontrol('Parent',tab1,'Style','text','units','normalized','HorizontalAlignment','Center','Position',[0.02 0.17 0.03 0.05],'String','Pixel X (Column)');
PixX_handle=uicontrol('Parent',tab1,'Style','edit','tag','PixX','units','normalized','Position',[0.01 0.13 0.05 0.05],'String',num2str(StartingX),'Callback',@Input_Pixels);
uicontrol('Parent',tab1,'Style','text','units','normalized','HorizontalAlignment','Center','Position',[0.092 0.17 0.03 0.05],'String','Pixel Y (Line)');
PixY_handle=uicontrol('Parent',tab1,'Style','edit','tag','PixY','units','normalized','Position',[0.08 0.13 0.05 0.05],'String',num2str(StartingY),'Callback',@Input_Pixels);
%Binning
uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.15 0.17 0.05 0.05],'String','Binning');
Bin_handle=uicontrol('Parent',tab1,'Style','edit','tag','Bin_txt','units','normalized','Position',[0.15 0.13 0.05 0.05],'String',num2str(StartingBin),'Tooltip','side of the binning square if BinThr < 100 ; else automatic binning using BinThr as a target luminescence threshold (more info in extractEsrThr)','Callback',@UpdateBinning);
%Temperature 
uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.22 0.17 0.05 0.05],'String','Temperature');
Temp_handle=uicontrol('Parent',tab1,'Style','text','tag','Temp_txt','units','normalized','Position',[0.22 0.13 0.05 0.035],'String','-');


%Pixel Calibration
bg = uibuttongroup('Parent',tab1,'units','normalized',...
                  'Position',[0.28 0.16 0.07 0.08],'tag','calibunit',...
                  'SelectionChangedFcn',@CalibUnitOpenESR);              
                            
r1 = uicontrol(bg,'Style',...
                  'radiobutton','units','normalized',...
                  'String','pixel','FontSize',8,'tag','calib_pixel_r1',...
                  'Position',[0 0.2 0.5 0.3]);
              
r2 = uicontrol(bg,'Style','radiobutton','units','normalized',...
                  'String','microns','FontSize',8,'tag','calib_nm_r2',...
                  'Position',[0.45 0.2 0.5 0.3]);
              
if strcmp(AcqParameters.CalibUnit_str,'pixel')
   bg.SelectedObject = r1;
else
    bg.SelectedObject = r2;
end

uicontrol('Parent',bg,'Style','text','FontSize',8,'units','normalized','HorizontalAlignment','left','Position',[0 0.7 0.45 0.2],'String','1 pixel');
uicontrol('Parent',bg,'Style','edit','tag','pixelcalibvalue','FontSize',8,'units','normalized','Position',[0.45 0.7 0.3 0.2],'String',num2str(AcqParameters.PixelCalib_nm),'Callback',@CalibUnitOpenESR);
uicontrol('Parent',bg,'Style','text','FontSize',8,'units','normalized','HorizontalAlignment','left','Position',[0.775 0.7 0.2 0.2],'String','nm');              


% Num Peaks
bg_np = uibuttongroup('Parent',tab1,'units','normalized',...
                  'Position',[0.25 0.24 0.10 0.04],'tag','NumPeaksChoice',...
                  'SelectionChangedFcn',@Input_Peaks);         
              
r0_np = uicontrol(bg_np,'Style',...
                  'radiobutton','units','normalized',...
                  'String','1','FontSize',12,'tag','NumPeaks1',...
                  'Position',[0.32 0.01 0.25 1]);              
                            
r1_np = uicontrol(bg_np,'Style',...
                  'radiobutton','units','normalized',...
                  'String','2','FontSize',12,'tag','NumPeaks2',...
                  'Position',[0.50 0.01 0.25 1]);
              
r2_np = uicontrol(bg_np,'Style',...
                  'radiobutton','units','normalized',...
                  'String','4','FontSize',12,'tag','NumPeaks4',...
                  'Position',[0.68 0.01 0.25 1]);              
              
r3_np = uicontrol(bg_np,'Style','radiobutton','units','normalized',...
                  'String','8','FontSize',12,'tag','NumPeaks8',...
                  'Position',[0.86 0.01 0.25 1]);            
              
uicontrol('Parent',bg_np,'Style','text','FontSize',12,'units','normalized','Position',[0.01 0.3 0.3 0.5],'HorizontalAlignment','left','String','Peaks');

%%%%%%%%%%%%%%%%%%
%%Text Information
%%%%%%%%%%%%%%%%%%
sizeM = size(M);
RefMWOffString  = 'No Ref MW Off';

uicontrol('Parent',tab1,'Style','text','tag','fname','units','normalized','FontSize',16,'HorizontalAlignment','left','FontWeight','bold','Position',[0.01 0.23 0.24 0.035],'String',['File: ' AcqParameters.nomSave]);
TextInfo9_Handle=uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.01 0.1 0.09 0.02],'tag','StrRefMWOff','HorizontalAlignment','left','String',RefMWOffString);
TextInfo2_Handle=uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.01 0.07 0.09 0.02],'tag','StrAcqTime','HorizontalAlignment','left','String',['Acquisition time = ' num2str(AcquisitionTime_minutes) ' minutes']);
TextInfo3_Handle=uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.01 0.04 0.09 0.02],'tag','StrNumSweeps','HorizontalAlignment','left','String',['Number of sweeps = ' num2str(Acc)]);
TextInfo4_Handle=uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.01 0.01 0.09 0.02],'tag','SizeOfM','HorizontalAlignment','left','String',['Size of M : (w,h,v) = (' num2str(sizeM(2)) ',' num2str(sizeM(1)) ',' num2str(sizeM(3)) ')']);
TextInfo5_Handle=uicontrol('Parent',tab1,'Style','text','units','normalized','HorizontalAlignment','left','Position',[0.12 0.07 0.07 0.02],'tag','StrCamType','String',['Camera ' CameraType]);
TextInfo6_Handle=uicontrol('Parent',tab1,'Style','text','units','normalized','HorizontalAlignment','left','Position',[0.12 0.04 0.07 0.02],'tag','StrMWPower','String',['MW Power = ' num2str(AcqParameters.MWPower) ' dBm']);
TextInfo7_Handle=uicontrol('Parent',tab1,'Style','text','units','normalized','HorizontalAlignment','left','Position',[0.12 0.01 0.08 0.02],'tag','StrExposureTime','String',['Exposure Time = ' num2str(round(AcqParameters.ExposureTime,3)) ' ' AcqParameters.ExposureUnit]);
TextInfo8_Handle=uicontrol('Parent',tab1,'Style','text','units','normalized','HorizontalAlignment','left','Position',[0.12 0.01 0.07 0.02],'tag','RefMWOff','String',['RefMWOff = ' num2str(AcqParameters.RefMWOff)],'Visible','off');
% trick to store parameters: use a 'visible','off' handle > could be used more

text(1.02,0.87,num2str(1),'FontSize',12,'Tag','lum1text','Units','Normalized','Parent',ax2,'Color','black');
text(1.02,0.87,num2str(1),'FontSize',12,'Tag','lum0text','Units','Normalized','Parent',ax3,'Color','black');

