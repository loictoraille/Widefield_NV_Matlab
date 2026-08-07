
%%Elements of Tab Control Coils (Matesy version)
load([getPath('Param') 'AcqParameters.mat']);

TAB = tab_controlcoil;
OffsetVertical = -0.01;

%% Shared left-column constants
FtSize      = 11;   % standard control font size
TitleFtSize = 14;   % section title font size
rowH        = 0.045; % standard row height/spacing

%% Coils Calibration

X0 = 0.02;  % left edge of section
Y0 = 0.25;  % top of section (title row)

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',TitleFtSize,'FontWeight','bold',...
    'Position',[X0+0.013 Y0 0.12 0.04],'String','Coils Calibration');

Row1 = Y0-0.07; Row2 = Row1-rowH; Row3 = Row2-rowH;

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left','Position',[X0 Row1+OffsetVertical 0.06 rowH],'String','Bxc = ');
uicontrol('Parent',TAB,'Style','edit','tag','XcoilCalib','units','normalized','FontSize',FtSize,'Position',[X0+0.04 Row1 0.07 rowH],'String',num2str(AcqParameters.XcoilCalib),'Callback',@UpdateAcqParam);
uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left','Position',[X0+0.12 Row1+OffsetVertical 0.06 rowH],'String','mT/V');

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left','Position',[X0 Row2+OffsetVertical 0.06 rowH],'String','Byc = ');
uicontrol('Parent',TAB,'Style','edit','tag','YcoilCalib','units','normalized','FontSize',FtSize,'Position',[X0+0.04 Row2 0.07 rowH],'String',num2str(AcqParameters.YcoilCalib),'Callback',@UpdateAcqParam);
uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left','Position',[X0+0.12 Row2+OffsetVertical 0.06 rowH],'String','mT/V');

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left','Position',[X0 Row3+OffsetVertical 0.06 rowH],'String','Bzc = ');
uicontrol('Parent',TAB,'Style','edit','tag','ZcoilCalib','units','normalized','FontSize',FtSize,'Position',[X0+0.04 Row3 0.07 rowH],'String',num2str(AcqParameters.ZcoilCalib),'Callback',@UpdateAcqParam);
uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left','Position',[X0+0.12 Row3+OffsetVertical 0.06 rowH],'String','mT/V');

%% Current State

X0 = 0.17;
Y0 = 0.25;

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',TitleFtSize,'FontWeight','bold',...
    'Position',[X0+0.02 Y0 0.18 0.04],'String','Current State');

Row1 = Y0-0.08; Row2 = Row1-rowH; Row3 = Row2-rowH;

uicontrol('Parent',TAB,'Style','text','tag','CoilState','units','normalized','FontSize',TitleFtSize,'FontWeight','bold',...
    'ForegroundColor','r','Position',[X0+0.05 Row2-0.01 0.09 rowH*1.3],'String','OFF','HorizontalAlignment','left');

uicontrol('Parent',TAB,'Style','text','tag','Vxc','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[X0+0.10 Row1 0.10 rowH],'String','Vxc = 0 V','Value',0);
uicontrol('Parent',TAB,'Style','text','tag','Vyc','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[X0+0.10 Row2 0.10 rowH],'String','Vyc = 0 V','Value',0);
uicontrol('Parent',TAB,'Style','text','tag','Vzc','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[X0+0.10 Row3 0.10 rowH],'String','Vzc = 0 V','Value',0);

%% Coil Components

X0 = 0.02;
Y0 = 0.56;

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',TitleFtSize,'FontWeight','bold',...
    'Position',[X0 Y0 0.22 0.04],'String','Coil Components');

BButton=uicontrol('Parent',TAB,'Style','togglebutton','String','OFF','units','normalized','tag','Bbutton',...
    'Position',[X0+0.01 Y0-0.12 0.08 0.06],'FontSize',TitleFtSize,'FontWeight','bold','ForegroundColor','r',...
    'Value',0,'Callback',@BButtonCall);

Row1 = Y0-0.07; Row2 = Row1-rowH; Row3 = Row2-rowH;
LabelX = X0+0.1; EditX = X0+0.13; UnitX = X0+0.20;

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left','Position',[LabelX Row1+OffsetVertical 0.06 rowH],'String','Bxc = ');
B_x_handle=uicontrol('Parent',TAB,'Style','edit','tag','BxCoil','units','normalized','FontSize',FtSize,'Position',[EditX Row1 0.05 rowH],'String',num2str(AcqParameters.BxCoil),'Callback',@B_Comp);
uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left','Position',[UnitX Row1+OffsetVertical 0.04 rowH],'String','mT');

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left','Position',[LabelX Row2+OffsetVertical 0.06 rowH],'String','Byc = ');
B_y_handle=uicontrol('Parent',TAB,'Style','edit','tag','ByCoil','units','normalized','FontSize',FtSize,'Position',[EditX Row2 0.05 rowH],'String',num2str(AcqParameters.ByCoil),'Callback',@B_Comp);
uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left','Position',[UnitX Row2+OffsetVertical 0.04 rowH],'String','mT');

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left','Position',[LabelX Row3+OffsetVertical 0.06 rowH],'String','Bzc = ');
B_z_handle=uicontrol('Parent',TAB,'Style','edit','tag','BzCoil','units','normalized','FontSize',FtSize,'Position',[EditX Row3 0.05 rowH],'String',num2str(AcqParameters.BzCoil),'Callback',@B_Comp);
uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left','Position',[UnitX Row3+OffsetVertical 0.04 rowH],'String','mT');

Bstart = floor(sqrt(AcqParameters.BxCoil^2+AcqParameters.ByCoil^2+AcqParameters.BzCoil^2)*100)/100;
NormRow = Row3-rowH-0.01;

uicontrol('Parent',TAB,'Style','text','string','B = ','units','normalized','FontSize',FtSize,'FontWeight','bold',...
    'HorizontalAlignment','left','Position',[X0+0.03 NormRow+OffsetVertical 0.05 rowH]);
B_norm_1=uicontrol('Parent',TAB,'Style','edit','String',num2str(Bstart),'tag','BnormCoil','units','normalized',...
    'FontSize',FtSize,'FontWeight','bold','Position',[X0+0.06 NormRow 0.08 rowH],'Callback',@B_normFunction);
uicontrol('Parent',TAB,'Style','text','string',' mT','units','normalized','FontSize',FtSize,'FontWeight','bold',...
    'HorizontalAlignment','left','Position',[X0+0.15 NormRow+OffsetVertical 0.05 rowH]);

%% Preset Parameters

X0 = 0.02;
Y0 = 0.93;

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',TitleFtSize,'FontWeight','bold',...
    'Position',[X0 Y0 0.22 0.04],'String','Preset parameters');

BtnW = 0.08; BtnH = 0.04; RowGap = 0.055;
Row = Y0-0.06;

uicontrol('Parent',TAB,'Style','pushbutton','String','B1','units','normalized','tag','B1Rec','Position',[X0 Row BtnW BtnH],'FontSize',FtSize,'Callback',@RecallAllFunction);
uicontrol('Parent',TAB,'Style','pushbutton','String','Store','units','normalized','tag','B1Store','Position',[X0+BtnW Row BtnW BtnH],'FontSize',FtSize,'Callback',@StoreAllFunction);
uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left','Position',[X0+2*BtnW+0.01 Row+OffsetVertical 0.12 BtnH],'String','Split 4');

Row = Row-RowGap;
uicontrol('Parent',TAB,'Style','pushbutton','String','B2','units','normalized','tag','B2Rec','Position',[X0 Row BtnW BtnH],'FontSize',FtSize,'Callback',@RecallAllFunction);
uicontrol('Parent',TAB,'Style','pushbutton','String','Store','units','normalized','tag','B2Store','Position',[X0+BtnW Row BtnW BtnH],'FontSize',FtSize,'Callback',@StoreAllFunction);
uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left','Position',[X0+2*BtnW+0.01 Row+OffsetVertical 0.12 BtnH],'String','All equal');

Row = Row-RowGap;
uicontrol('Parent',TAB,'Style','pushbutton','String','B3','units','normalized','tag','B3Rec','Position',[X0 Row BtnW BtnH],'FontSize',FtSize,'Callback',@RecallAllFunction);
uicontrol('Parent',TAB,'Style','pushbutton','String','Store','units','normalized','tag','B3Store','Position',[X0+BtnW Row BtnW BtnH],'FontSize',FtSize,'Callback',@StoreAllFunction);
uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left','Position',[X0+2*BtnW+0.01 Row+OffsetVertical 0.12 BtnH],'String','1 only');

Row = Row-RowGap;
uicontrol('Parent',TAB,'Style','pushbutton','String','B4','units','normalized','tag','B4Rec','Position',[X0 Row BtnW BtnH],'FontSize',FtSize,'Callback',@RecallAllFunction);
uicontrol('Parent',TAB,'Style','pushbutton','String','Store','units','normalized','tag','B4Store','Position',[X0+BtnW Row BtnW BtnH],'FontSize',FtSize,'Callback',@StoreAllFunction);
uicontrol('Parent',TAB,'Style','edit','units','normalized','FontSize',FtSize,'tag','Bname_User1','Position',[X0+2*BtnW+0.01 Row 0.07 BtnH],'String',AcqParameters.Bname_User1,'HorizontalAlignment','left','Callback',@UpdateAcqParam);

Row = Row-RowGap;
uicontrol('Parent',TAB,'Style','pushbutton','String','B5','units','normalized','tag','B5Rec','Position',[X0 Row BtnW BtnH],'FontSize',FtSize,'Callback',@RecallAllFunction);
uicontrol('Parent',TAB,'Style','pushbutton','String','Store','units','normalized','tag','B5Store','Position',[X0+BtnW Row BtnW BtnH],'FontSize',FtSize,'Callback',@StoreAllFunction);
uicontrol('Parent',TAB,'Style','edit','units','normalized','FontSize',FtSize,'tag','Bname_User2','Position',[X0+2*BtnW+0.01 Row 0.07 BtnH],'String',AcqParameters.Bname_User2,'HorizontalAlignment','left','Callback',@UpdateAcqParam);

%% Connection

% X0 = 0.80;
% Y0 = 0.965;
% 
% ConnectionString = 'NOT connected';
% ConnectionColor = 'r';
% 
% uicontrol('Parent',TAB,'Style','text','tag','ConnectionCoils','units','normalized','FontSize',13,'FontWeight','bold',...
%     'Position',[X0 Y0 0.15 0.03],'String',ConnectionString,'ForegroundColor',ConnectionColor);

%% Magnetic Scan Parameters (shared prefix)

MS = AcqParameters.MagneticScan; % shortcut for initial values only

%% Scan Theta

VerticalPosition = 0.96; % top of area (y)
BottomPosition   = 0.55; % bottom of area (y), also axes bottom
LateralPosition  = 0.46; % left of right-hand column
WidthStep        = 0.49; % total width used by this area

hB       = 0.04;   % control height
FtSize   = 11;
RowGap   = 0.03;

Denomination = 'Scan Theta';

TextInfo_Handle=uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize+3,'FontWeight','bold',...
    'Position',[LateralPosition VerticalPosition WidthStep 0.04],'String',Denomination);

% -- Row 1: enable + range + step --
Row1Y = VerticalPosition - RowGap;

uicontrol('Parent',TAB,'Style','checkbox','units','normalized','tag','ScanTheta_Enable',...
    'Position',[LateralPosition Row1Y 0.03 hB],'Value',MS.ScanTheta_Enable,'Callback',@UpdateAcqParam);

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[LateralPosition+0.01 Row1Y+OffsetVertical 0.14 hB],'String','Scan theta between');

uicontrol('Parent',TAB,'Style','edit','units','normalized','FontSize',FtSize,'tag','ScanTheta_AngleStart',...
    'Position',[LateralPosition+0.085 Row1Y 0.03 hB],'String',num2str(MS.ScanTheta_AngleStart),'Callback',@UpdateAcqParam);

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,...
    'Position',[LateralPosition+0.115 Row1Y+OffsetVertical 0.02 hB],'String','and');

uicontrol('Parent',TAB,'Style','edit','units','normalized','FontSize',FtSize,'tag','ScanTheta_AngleStop',...
    'Position',[LateralPosition+0.135 Row1Y 0.03 hB],'String',num2str(MS.ScanTheta_AngleStop),'Callback',@UpdateAcqParam);

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[LateralPosition+0.17 Row1Y+OffsetVertical 0.08 hB],'String','by steps of');

uicontrol('Parent',TAB,'Style','edit','units','normalized','FontSize',FtSize,'tag','ScanTheta_AngleStep',...
    'Position',[LateralPosition+0.21 Row1Y 0.03 hB],'String',num2str(MS.ScanTheta_AngleStep),'Callback',@UpdateAcqParam);

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[LateralPosition+0.245 Row1Y+OffsetVertical 0.08 hB],'String','deg');

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[LateralPosition+0.31 Row1Y+OffsetVertical 0.05 hB],'String','phi = ');

uicontrol('Parent',TAB,'Style','edit','units','normalized','FontSize',FtSize,'tag','ScanTheta_PhiValue',...
    'Position',[LateralPosition+0.33 Row1Y 0.03 hB],'String',num2str(MS.ScanTheta_PhiValue),'Callback',@UpdateAcqParam);

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[LateralPosition+0.365 Row1Y+OffsetVertical 0.08 hB],'String','deg');

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[LateralPosition+0.40 Row1Y+OffsetVertical 0.05 hB],'String','B = ');

uicontrol('Parent',TAB,'Style','edit','units','normalized','FontSize',FtSize,'tag','ScanTheta_MagneticFieldValue',...
    'Position',[LateralPosition+0.415 Row1Y 0.03 hB],'String',num2str(MS.ScanTheta_MagneticFieldValue),'Callback',@UpdateAcqParam);

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[LateralPosition+0.4525 Row1Y+OffsetVertical+0.02 0.04 0.02],'String','mT');

% -- Plot area (filled later) --
AxesTop = Row1Y-0.01;
ScanTheta_Axes = axes('Parent',TAB,'units','normalized',...
    'Position',[LateralPosition BottomPosition WidthStep AxesTop-BottomPosition],...
    'Tag','ScanTheta_Axes');
imagesc(ScanTheta_Axes, NaN(2,2));
axis(ScanTheta_Axes,'xy');
set(ScanTheta_Axes,'Box','on');
xlim([MS.ScanTheta_AngleStart MS.ScanTheta_AngleStop])
ylim([AcqParameters.FCenter-0.001*AcqParameters.FSpan/2 AcqParameters.FCenter+0.001*AcqParameters.FSpan/2])
xlabel(ScanTheta_Axes,'\theta (deg)');
ylabel(ScanTheta_Axes,'MW Frequency (GHz)');
set(ScanTheta_Axes,'Tag','ScanTheta_Axes'); % Necessary to rewrite tag of axes after imagesc (I don't know why)

%% Scan Phi (mirrors Scan Theta)

VerticalPosition = 0.46; % top of area (y) - sits just below Scan Theta's axes (bottom = 0.54)
BottomPosition   = 0.05; % bottom of area (y) - just above the Start Scan button
LateralPosition  = 0.46;
WidthStep        = 0.49;

hB       = 0.04;
FtSize   = 11;
RowGap   = 0.03;

Denomination = 'Scan Phi';

TextInfo_Handle=uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize+3,'FontWeight','bold',...
    'Position',[LateralPosition VerticalPosition WidthStep 0.04],'String',Denomination);

% -- Single row: enable + range + step + theta + B --
Row1Y = VerticalPosition - RowGap;

uicontrol('Parent',TAB,'Style','checkbox','units','normalized','tag','ScanPhi_Enable',...
    'Position',[LateralPosition Row1Y 0.03 hB],'Value',MS.ScanPhi_Enable,'Callback',@UpdateAcqParam);

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[LateralPosition+0.01 Row1Y+OffsetVertical 0.14 hB],'String','Scan phi between');

uicontrol('Parent',TAB,'Style','edit','units','normalized','FontSize',FtSize,'tag','ScanPhi_AngleStart',...
    'Position',[LateralPosition+0.085 Row1Y 0.03 hB],'String',num2str(MS.ScanPhi_AngleStart),'Callback',@UpdateAcqParam);

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,...
    'Position',[LateralPosition+0.115 Row1Y+OffsetVertical 0.02 hB],'String','and');

uicontrol('Parent',TAB,'Style','edit','units','normalized','FontSize',FtSize,'tag','ScanPhi_AngleStop',...
    'Position',[LateralPosition+0.135 Row1Y 0.03 hB],'String',num2str(MS.ScanPhi_AngleStop),'Callback',@UpdateAcqParam);

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[LateralPosition+0.17 Row1Y+OffsetVertical 0.08 hB],'String','by steps of');

uicontrol('Parent',TAB,'Style','edit','units','normalized','FontSize',FtSize,'tag','ScanPhi_AngleStep',...
    'Position',[LateralPosition+0.21 Row1Y 0.03 hB],'String',num2str(MS.ScanPhi_AngleStep),'Callback',@UpdateAcqParam);

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[LateralPosition+0.245 Row1Y+OffsetVertical 0.08 hB],'String','deg');

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[LateralPosition+0.31 Row1Y+OffsetVertical 0.05 hB],'String','theta = ');

uicontrol('Parent',TAB,'Style','edit','units','normalized','FontSize',FtSize,'tag','ScanPhi_ThetaValue',...
    'Position',[LateralPosition+0.34 Row1Y 0.03 hB],'String',num2str(MS.ScanPhi_ThetaValue),'Callback',@UpdateAcqParam);

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[LateralPosition+0.375 Row1Y+OffsetVertical 0.08 hB],'String','deg');

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[LateralPosition+0.41 Row1Y+OffsetVertical 0.05 hB],'String','B = ');

uicontrol('Parent',TAB,'Style','edit','units','normalized','FontSize',FtSize,'tag','ScanPhi_MagneticFieldValue',...
    'Position',[LateralPosition+0.425 Row1Y 0.03 hB],'String',num2str(MS.ScanPhi_MagneticFieldValue),'Callback',@UpdateAcqParam);

uicontrol('Parent',TAB,'Style','text','units','normalized','FontSize',FtSize,'HorizontalAlignment','left',...
    'Position',[LateralPosition+0.4625 Row1Y+OffsetVertical+0.02 0.04 0.02],'String','mT');

% -- Plot area (filled later) --
AxesTop = Row1Y-0.01;
ScanPhi_Axes = axes('Parent',TAB,'units','normalized',...
    'Position',[LateralPosition BottomPosition WidthStep AxesTop-BottomPosition],...
    'Tag','ScanPhi_Axes');
imagesc(ScanPhi_Axes, NaN(2,2));
axis(ScanPhi_Axes,'xy');
set(ScanPhi_Axes,'Box','on');
xlim([MS.ScanPhi_AngleStart MS.ScanPhi_AngleStop])
ylim([AcqParameters.FCenter-0.001*AcqParameters.FSpan/2 AcqParameters.FCenter+0.001*AcqParameters.FSpan/2])
xlabel(ScanPhi_Axes,'\phi (deg)');
ylabel(ScanPhi_Axes,'MW Frequency (GHz)');
set(ScanPhi_Axes,'Tag','ScanPhi_Axes'); % Necessary to rewrite tag of axes after imagesc (I don't know why)

%% Start Scan Button

LateralPosition = 0.33; % pushed left of the graphs' column, roughly centered on the whole figure
WidthStep       = 0.1;
ButtonHeight    = 0.06;
ButtonY         = 0.47;
FtSize          = 16;

uicontrol('Parent',TAB,'Style','pushbutton','String','Start Scan','units','normalized','tag','StartScanButton',...
    'Position',[LateralPosition ButtonY WidthStep ButtonHeight],'FontSize',FtSize,'FontWeight','bold','ForegroundColor',[1,0,0],...
    'Callback',@StartMagneticScan);

%% Textbox formula reminder defining theta and phi

FormulaFtSize = 13;
FormulaRowH   = 0.025;
FormulaRowW   = 0.08;
FormulaX0     = 0.33;
FormulaY0     = 0.8;

annotation(TAB,'textbox',[FormulaX0 FormulaY0 FormulaRowW FormulaRowH],...
    'String','$B_x = B\cos\theta$','Interpreter','latex','FontSize',FormulaFtSize,...
    'EdgeColor','none','HorizontalAlignment','left','VerticalAlignment','middle');

annotation(TAB,'textbox',[FormulaX0 FormulaY0-FormulaRowH FormulaRowW FormulaRowH],...
    'String','$B_y = B\sin\theta\cos\phi$','Interpreter','latex','FontSize',FormulaFtSize,...
    'EdgeColor','none','HorizontalAlignment','left','VerticalAlignment','middle');

annotation(TAB,'textbox',[FormulaX0 FormulaY0-2*FormulaRowH FormulaRowW FormulaRowH],...
    'String','$B_z = B\sin\theta\sin\phi$','Interpreter','latex','FontSize',FormulaFtSize,...
    'EdgeColor','none','HorizontalAlignment','left','VerticalAlignment','middle');

% Border marking the edges of the whole formula box
annotation(TAB,'rectangle',[FormulaX0-0.005 FormulaY0-2*FormulaRowH-0.005 FormulaRowW+0.005 3*FormulaRowH+0.01],...
    'Color',[0 0 0],'LineWidth',1);