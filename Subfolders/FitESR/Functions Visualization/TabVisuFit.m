%Visual elements of VisuFit function

%Full ESR image
hp1 = uipanel('Parent',tab1,'Title','Sample Image Lum vs XY','FontSize',12,'FontWeight','bold',...
    'BackgroundColor','white','Position',[0 0.45 .5 .45]);
Ax1 = axes('Parent',hp1,'tag','EsrImg','Position',[0.1 0.15  0.8 0.8]);


%ESR on one pixel plus fit result
hp2 = uipanel('Parent',tab1,'Title','ODMR Spectrum','FontSize',12,'FontWeight','bold',...
    'BackgroundColor','white','Position',[0.5 0 .5 .45]);
Ax2 = axes('Parent',hp2,'tag','SpectreFit','Position',[0.1 0.15  0.8 0.8]);

%Plot X NU
hp3 = uipanel('Parent',tab1,'Title','Lum vs XNu','FontSize',12,'FontWeight','bold',...
    'BackgroundColor','white','Position',[0 0 .5 .45]);
Ax3 = axes('Parent',hp3,'tag','EsrImgxNU','Position',[0.1 0.15  0.8 0.8]);

%Plot Y NU
hp4 = uipanel('Parent',tab1,'Title','Lum vs YNu','FontSize',12,'FontWeight','bold',...
    'BackgroundColor','white','Position',[0.5 0.45 .5 .45]);
Ax4 = axes('Parent',hp4,'tag','EsrImgyNU','Position',[0.1 0.15  0.8 0.8]);

%To change selected pixel
PixelButton=uicontrol('Parent',tab1,'Style','togglebutton','String','Pixel','units','normalized','tag','PixVisuFit',...
    'Position', [0.195 0.91 0.1 0.06],'FontSize',20,'ForegroundColor',[1,0,0],...
    'Callback',@(object,eventdata) PixelFunctionVisuFit(object,eventdata,ESRMatrix,x_start,y_start,x_stoptoend,y_stoptoend,v_MHz,FitTot,BinThr,VarWidths,NumComp,IsPair,Smoothing_Factor,Detrending_Factor,ClearFFT,RemPositive, FitParameters));

TextInfo_Handle=uicontrol('Parent',tab1,'Style','text','units','normalized','FontSize',12,'FontWeight','bold','Position',[0 0.97 0.5 0.03],'String',SaveName);