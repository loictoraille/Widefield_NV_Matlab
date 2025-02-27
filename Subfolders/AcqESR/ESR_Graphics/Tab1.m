%%Elements of Tab1 (ESR) 
load([getPath('Param') 'AcqParameters.mat']);

if TestWithoutHardware
    valuetestwohar = 'on';
else    
    valuetestwohar = 'off';
end

%%%%%%%%
%%Acquisition parameters
%%%%%%%%
cpanel1=uipanel('Parent',tab1,'Position',[0.075 0.88 0.145 0.12]);
cpanel2=uipanel('Parent',tab1,'Position',[0.22 0.88 0.202 0.12]);
uicontrol('Parent',tab1,'Style', 'checkbox', 'String', 'Save','units','normalized','tag','Save',...
    'Position', [0.076 0.883 0.07 0.025],'FontSize',10,'Value',AcqParameters.Save,'Callback',@UpdateAcqParam);
uicontrol('Parent',tab1,'Style', 'checkbox', 'String', 'AutoAlignPiezo','units','normalized','tag','AutoAlignPiezo',...
    'Position', [0.076 0.973 0.07 0.025],'FontSize',10,'Value',AcqParameters.AutoAlignPiezo,'Callback',@UpdateAutoAlignPiezo);
uicontrol('Parent',tab1,'Style', 'checkbox', 'String', 'RefreshMode','units','normalized','tag','RefreshMode',...
    'Position', [0.15 0.943 0.065 0.025],'FontSize',10,'Tooltip','Does not accumulate the ESR Spectra and divides NumPoints by 4','Value',AcqParameters.RefreshMode,'Callback',@UpdateAcqParam);
uicontrol('Parent',tab1,'Style', 'checkbox', 'String', 'ReadTemp','units','normalized','tag','ReadTemp',...
    'Position', [0.076 0.943 0.065 0.025],'FontSize',10,'Value',AcqParameters.ReadTemp,'Callback',@UpdateAcqParam);
uicontrol('Parent',tab1,'Style', 'checkbox', 'String', 'AutoAlignCam','units','normalized','tag','AutoAlignCam',...
    'Position', [0.15 0.973 0.066 0.025],'FontSize',10,'Value',AcqParameters.AutoAlignCam,'Callback',@UpdateAutoAlignCam);
uicontrol('Parent',tab1,'Style', 'checkbox', 'String', 'DelEx','units','normalized','tag','DelEx',...
    'Position', [0.15 0.883 0.065 0.025],'FontSize',10,'Value',AcqParameters.DelEx,'Tooltip','Deletes first and last frequency points before plotting and saving file','Callback',@UpdateAcqParam);

uicontrol('Parent',tab1,'Style', 'checkbox', 'String', 'Autofocus every','units','normalized','tag','AF','Position', [0.076 0.913 0.065 0.025],'FontSize',10,'Value',AcqParameters.AF,'Tooltip','Autofocus piezo Z every X sweeps during a scan','Callback',@UpdateAcqParam);
uicontrol('Parent',tab1,'Style','edit','tag','AF_NumberSweeps','FontSize',10,'units','normalized','Position',[0.140 0.913 0.02 0.025],'String',num2str(AcqParameters.AF_NumberSweeps),'Callback',@UpdateAcqParam);
uicontrol('Parent',tab1,'Style','text','FontSize',10,'units','normalized','HorizontalAlignment','left','Position',[0.162 0.913 0.034 0.022],'String','sweeps');  

uicontrol('Parent',tab1,'Style', 'text', 'String', sprintf('TEST WITHOUT\n HARDWARE'),'ForegroundColor','red','units','normalized','tag','testwohar',...
    'Position', [0.076 0.917 0.085 0.05],'FontSize',15,'FontWeight','bold','VISIBLE',valuetestwohar);

uicontrol('Parent',tab1,'Style','text','FontSize',10,'units','normalized','HorizontalAlignment','right','Position',[0.235 0.968 0.041 0.025],'String','MWPower');
uicontrol('Parent',tab1,'Style','edit','tag','MWPower','FontSize',10,'units','normalized','Position',[0.279 0.973 0.02 0.025],'String',num2str(AcqParameters.MWPower),'Callback',@UpdateAcqParam);
uicontrol('Parent',tab1,'Style','text','FontSize',10,'units','normalized','HorizontalAlignment','left','Position',[0.301 0.968 0.02 0.025],'String','dBm');
    
uicontrol('Parent',tab1,'Style','text','FontSize',10,'units','normalized','HorizontalAlignment','right','Position',[0.227 0.938 0.05 0.025],'String','NumPoints');
uicontrol('Parent',tab1,'Style','edit','tag','NumPoints','FontSize',10,'units','normalized','Position',[0.279 0.943 0.02 0.025],'String',num2str(AcqParameters.NumPoints),'Callback',@UpdateAcqParam);

uicontrol('Parent',tab1,'Style','text','FontSize',10,'units','normalized','HorizontalAlignment','right','Position',[0.227 0.909 0.05 0.025],'String','NumSweeps');
uicontrol('Parent',tab1,'Style','edit','tag','NumSweeps','FontSize',10,'units','normalized','Position',[0.279 0.913 0.02 0.025],'String',num2str(AcqParameters.NumSweeps),'Callback',@UpdateAcqParam);

uicontrol('Parent',tab1,'Style','text','FontSize',10,'units','normalized','HorizontalAlignment','right','Position',[0.33 0.968 0.043 0.025],'String','FCenter');
uicontrol('Parent',tab1,'Style','edit','tag','FCenter','FontSize',10,'units','normalized','Position',[0.375 0.973 0.025 0.025],'String',num2str(AcqParameters.FCenter),'Callback',@UpdateAcqParam);
uicontrol('Parent',tab1,'Style','text','FontSize',10,'units','normalized','HorizontalAlignment','left','Position',[0.401 0.968 0.02 0.025],'String','GHz');

uicontrol('Parent',tab1,'Style','text','FontSize',10,'units','normalized','HorizontalAlignment','right','Position',[0.33 0.938 0.043 0.025],'String','FSpan');
uicontrol('Parent',tab1,'Style','edit','tag','FSpan','FontSize',10,'units','normalized','Position',[0.375 0.943 0.025 0.025],'String',num2str(AcqParameters.FSpan),'Callback',@UpdateAcqParam);
uicontrol('Parent',tab1,'Style','text','FontSize',10,'units','normalized','HorizontalAlignment','left','Position',[0.401 0.938 0.02 0.025],'String','MHz');

uicontrol('Parent',tab1,'Style','text','FontSize',10,'units','normalized','HorizontalAlignment','right','Position',[0.222 0.882 0.055 0.022],'String','Backup every');
uicontrol('Parent',tab1,'Style','edit','tag','BackupNSweeps','FontSize',10,'units','normalized','Position',[0.279 0.883 0.02 0.025],'String',num2str(AcqParameters.BackupNSweeps),'Callback',@UpdateAcqParam, 'TooltipString', 'Uses fast&heavy save mode to backup regularly during acquisition');
uicontrol('Parent',tab1,'Style','text','FontSize',10,'units','normalized','HorizontalAlignment','left','Position',[0.301 0.882 0.034 0.022],'String','sweeps');   

uicontrol('Parent',tab1,'Style','text','FontSize',10,'units','normalized','HorizontalAlignment','right','Position',[0.33 0.909 0.043 0.025],'String','RepeatScan');
uicontrol('Parent',tab1,'Style','edit','tag','RepeatScan','FontSize',10,'units','normalized','Position',[0.375 0.913 0.025 0.025],'String',num2str(AcqParameters.RepeatScan),'Callback',@UpdateAcqParam,...
    'Tooltip','To repeat the full acquisition with a new incremented name, the value is the total number of scans');

uicontrol('Parent',tab1,'Style','text','FontSize',10,'units','normalized','HorizontalAlignment','right','Position',[0.33 0.882 0.043 0.022],'String','RefMWOff');
uicontrol('Parent',tab1,'Style','edit','tag','RefMWOff','FontSize',10,'units','normalized','Position',[0.375 0.883 0.025 0.025],'String',num2str(AcqParameters.RefMWOff),'Callback',@UpdateAcqParam,...
    'Tooltip',['0: Standard mode' 10 '1: Divide by a single reference image taken at the start of each sweep' 10 '2: Divide by a reference image taken for each freq value' 10 'If mode 2 does not work, you probably go too fast for your MW generator, check its display']);

uicontrol('Parent',tab1,'Style', 'checkbox', 'String', 'Finish sweep','units','normalized','tag','FinishSweep',...
    'Position', [0.4295 0.887 0.065 0.025],'FontSize',10,'Value',AcqParameters.FinishSweep,'Callback',@UpdateAcqParam);

uicontrol('Parent',tab1,'Style', 'checkbox', 'String', 'MW always ON','units','normalized','tag','RFAlwaysON',...
    'Position', [0.005 0.887 0.065 0.025],'FontSize',10,'Value',0,'Callback',@UpdateRF); %start on 0 to prevent wire burning

%%%%%%%%
%%Graphs
%%%%%%%%
%Image taken at cycle start
hp = uipanel('Parent',tab1,'Title','Sample Image','FontSize',12,'FontWeight','bold',...
    'BackgroundColor','white','Position',[0 0.28 .50 .6]);
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
%%Buttons
%%%%%%%%%
%To compare spectra at 2 positions
CompButton=uicontrol('Parent',tab1,'Style', 'togglebutton', 'String', 'Compare','units','normalized','tag','comp',...
    'Position', [0.35 0.16 0.15 0.08],'FontSize',20,'ForegroundColor',[1,0,0],...
    'Value',0,'Callback',@CompareFunction);
%To stop acquisition
StopButton=uicontrol('Parent',tab1,'Style', 'togglebutton', 'String', 'STOP','units','normalized','tag','stop',...
    'Position', [0.425 0.92 0.07 0.08],'FontSize',20,'ForegroundColor',[1,0,0],...
    'Value',0);
%To start acquisition
StartButton=uicontrol('Parent',tab1,'Style', 'togglebutton', 'String', 'START','units','normalized','tag','start',...
    'Position', [0 0.92 0.07 0.08],'FontSize',20,'ForegroundColor',[1,0,0],...
    'Value',0,'Callback',@GUIStartFunction);
%To change selected pixel
PixelButton=uicontrol('Parent',tab1,'Style', 'togglebutton', 'String', 'Pix','units','normalized','tag','Pix',...
    'Position', [0.35 0 0.15 0.08],'FontSize',20,'ForegroundColor',[1,0,0],...
    'Callback',@PixelFunction);
%To print cursors
CursorButton=uicontrol('Parent',tab1,'Style', 'togglebutton', 'String', 'Cursor','units','normalized','tag','Cursor',...
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
%To use AutoBase or not
AutoBaseCheckBox=uicontrol('Parent',tab1,'Style', 'checkbox', 'String', 'AutoBase','units','normalized','tag','AutoBase',...
    'Position', [0.44 0.24 0.05 0.04],'FontSize',10,'Value',0,'Callback',@UpdateFit);
%To save backup file
SaveBackupButton=uicontrol('Parent',tab1,'Style', 'pushbutton', 'String', 'Save backup','units','normalized','tag','SaveBackup',...
    'Position', [0.28 0.20 0.07 0.04],'FontSize',16,'ForegroundColor',[0,0,0],'Tooltip','Takes the ''backup'' file and copy pastes it into a file following the naming rule','Callback',@SaveBackupFunction);
%To export shown ESR
ExportESRButton=uicontrol('Parent',tab1,'Style', 'pushbutton', 'String', 'ExportESR','units','normalized','tag','ExportESR',...
    'Position', [0.28 0.16 0.07 0.04],'FontSize',16,'Callback',@ExportESRFunction);


%%%%%%%%%%%%
%%Text boxes
%%%%%%%%%%%%
StartingX = 1;
StartingY = 1;
StartingBin = 5;
%Pixels chosen for the printed ESR
uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.012 0.15 0.05 0.05],'String','Pixel X (Column)');
PixX_handle=uicontrol('Parent',tab1,'Style','edit','tag','PixX','units','normalized','Position',[0.01 0.11 0.05 0.05],'String',num2str(StartingX),'Callback',@Input_Pixels);
uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.092 0.15 0.03 0.05],'String','Pixel Y (Line)');
PixY_handle=uicontrol('Parent',tab1,'Style','edit','tag','PixY','units','normalized','Position',[0.08 0.11 0.05 0.05],'String',num2str(StartingY),'Callback',@Input_Pixels);
%Binning
uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.15 0.15 0.05 0.05],'String','Binning');
Bin_handle=uicontrol('Parent',tab1,'Style','edit','tag','Bin_txt','units','normalized','Position',[0.15 0.11 0.05 0.05],'String',num2str(StartingBin),'Tooltip','side of the binning square if BinThr < 100 ; else automatic binning using BinThr as a target luminescence threshold (more info in extractEsrThr)','Callback',@Input_Pixels);
%Temperature 
uicontrol('Parent',tab1,'Style','text','units','normalized','Position',[0.22 0.15 0.05 0.05],'String','Temperature');
uicontrol('Parent',tab1,'Style','text','tag','Temp_txt','units','normalized','Position',[0.22 0.1  0.05 0.05],'String','-');

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
              
uicontrol('Parent',bg_np,'Style','text','FontSize',12,'units','normalized','Position',[0.01 0.3 0.3 0.45],'HorizontalAlignment','left','String','Peaks');


%%%%%%%%%%%%%%%%%%
%%Text Information
%%%%%%%%%%%%%%%%%%
uicontrol('Parent',tab1,'Style','text','tag','nameFile','units','normalized','FontSize',16,'HorizontalAlignment','left','FontWeight','bold','Position',[0.01 0.21 0.24 0.05],'String',['File: ' AcqParameters.nomSave]);
uicontrol('Parent',tab1,'Style','text','tag','numberSweep','units','normalized','FontSize',12,'HorizontalAlignment','right','Position',[0.13 0.05 0.13 0.03],'String',['Sweep number /' num2str(AcqParameters.NumSweeps)]);
uicontrol('Parent',tab1,'Style','text','tag','numberFreq','units','normalized','FontSize',12,'HorizontalAlignment','right','Position',[0.13 0.01 0.13 0.03],'String',['Freq number /' num2str(AcqParameters.NumPoints)]);

uicontrol('Parent',tab1,'Style','text','tag','sizeM','units','normalized','FontSize',12,'HorizontalAlignment','left','Position',[0.01 0.05 0.15 .03],'String','Size of M : (w,h,v) = (,,)');

text(1.02,0.87,num2str(1),'FontSize',12,'Tag','lum1text','Units','Normalized','Parent',ax2,'Color','black');
text(1.02,0.87,num2str(1),'FontSize',12,'Tag','lum0text','Units','Normalized','Parent',ax3,'Color','black');

uicontrol('Parent',tab1,'Style','text','FontSize',12,'HorizontalAlignment','left','units','normalized','Position',[0.01 0.01 0.15 0.03],'String','','tag','AcqTime');

clear AcqParameters