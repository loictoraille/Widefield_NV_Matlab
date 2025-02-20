function ExportESRFunction(~,~)
global M Ftot

load([getPath('Param') 'FileInfo.mat'],'-mat','Data_Path','fname');

[~,~] = mkdir(Data_Path, 'ExportESR');
[~,~] = mkdir([Data_Path 'ExportESR\'], 'Text Files');
[~,~] = mkdir([Data_Path 'ExportESR\'], 'Png Files');
[~,~] = mkdir([Data_Path 'ExportESR\'], 'Svg Files');

SavePathText = [Data_Path 'ExportESR\' 'Text Files\'];
SavePathPng = [Data_Path 'ExportESR\' 'Png Files\'];
SavePathSvg = [Data_Path 'ExportESR\' 'Svg Files\'];
% emf and pdf ?

panel=guidata(gcbo);

PixBin=str2double(panel.Bin_txt.String);
PixX = str2double(panel.PixX.String);
PixY = str2double(panel.PixY.String);

Mat = M;

Sp1=squeeze(Mat(PixY,PixX,:));            
Sp2=squeeze(mean(mean(Mat(PixY-floor((PixBin-1)/2):PixY+floor(PixBin/2),PixX-floor((PixBin-1)/2):PixX+floor(PixBin/2),:),1),2));
Sp1YData = panel.l21.YData.';
Sp2YData = panel.l31.YData.';


tag_fit = findobj('tag','Fit');         
Fit_Value = tag_fit.Value;

if Fit_Value
    Sp1FitYData = panel.l24.YData.';
    Sp2FitYData = panel.l34.YData.';
    StrFitResult1tag = findobj('tag','StrFitResult1');
    StrFitResult2tag = findobj('tag','StrFitResult2');
    StrFitResultBin1tag = findobj('tag','StrFitResultBin1');
    StrFitResultBin2tag = findobj('tag','StrFitResultBin2');
    StrFitResult1 = StrFitResult1tag.String;
    StrFitResult2 = StrFitResult2tag.String;
    StrFitResultBin1 =StrFitResultBin1tag.String;
    StrFitResultBin2 = StrFitResultBin2tag.String;
end

%% Plot ESR at a specific location
saveESR = 1; %saves ESR in svg, png and data form
FigureSize = 0.57; % choose small size for big text when saving
FigRatio = 3/2;
Line_Thickness_In = 1;

fig1 = figure('Name',[fname '-ESR Spectrum on point' '_x-' num2str(PixX) '_y-' num2str(PixY)],'Position',FigSizePosition(FigureSize,FigRatio));ax=gca;
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';
ax.FontName = 'Times New Roman';
ax.FontSize = 20;
ax.LineWidth = Line_Thickness_In;
hold on
plot(Ftot,Sp1YData,'o','Color','Black','MarkerFaceColor','Black')
if Fit_Value
    plot(Ftot,Sp1FitYData,'-','Color','Red','LineWidth',3)
    text(0.05,0.95,StrFitResult1,'FontSize',15,'Tag','StrFitResult1','Units','Normalized','Parent',ax,'Color','black');
    text(0.5,0.95,StrFitResult2,'FontSize',15,'Tag','StrFitResult2','Units','Normalized','Parent',ax,'Color','black');
end

xlabel([char(957) ' (GHz)']);
xlim([floor(Ftot(1)*100)/100 ceil(Ftot(end)*100)/100])
ylabel('Renormalized Luminescence (a.u.)','VerticalAlignment','bottom','HorizontalAlignment','center'); 

fig2 = figure('Name',[fname '-ESR Spectrum on point' '_x-' num2str(PixX) '_y-' num2str(PixY) '_withBinning-' num2str(PixBin)],'Position',FigSizePosition(FigureSize,FigRatio));
hold on
ax=gca;
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';
ax.FontName = 'Times New Roman';
ax.FontSize = 20;
ax.LineWidth = Line_Thickness_In;
plot(Ftot,Sp2YData,'o','Color','Black','MarkerFaceColor','Black')
if Fit_Value
    plot(Ftot,Sp2FitYData,'-','Color','Red','LineWidth',3)
    text(0.05,0.95,StrFitResultBin1,'FontSize',15,'Tag','StrFitResultBin1','Units','Normalized','Parent',ax,'Color','black');
    text(0.5,0.95,StrFitResultBin2,'FontSize',15,'Tag','StrFitResultBin2','Units','Normalized','Parent',ax,'Color','black');
end
xlabel([char(957) ' (GHz)']);
xlim([floor(Ftot(1)*100)/100 ceil(Ftot(end)*100)/100])
ylabel('Renormalized Luminescence (a.u.)','VerticalAlignment','bottom','HorizontalAlignment','center'); 


if saveESR == 1
    saveas(fig1,[SavePathPng fname '-ESR Spectrum' '_x-' num2str(PixX) '_y-' num2str(PixY) '.png'],'png');
    saveas(fig1,[SavePathSvg fname '-ESR Spectrum' '_x-' num2str(PixX) '_y-' num2str(PixY) '.svg'],'svg');
%     print(fig1,[SavePath fname '-ESR Spectrum' '_x-' num2str(PixX) '_y-' num2str(PixY) '.pdf'],'-dpdf','-bestfit');
%     saveas(fig1,[SavePath fname '-ESR Spectrum' '_x-' num2str(PixX) '_y-' num2str(PixY) '.emf'],'emf');
    
    MatOut1 = [Ftot Sp1 Sp1YData];
    if Fit_Value
        MatOut1 = [MatOut1 Sp1FitYData];
    end
    writematrix(MatOut1,[SavePathText fname '-ESR Spectrum' '_x-' num2str(PixX) '_y-' num2str(PixY) '.txt'],'Delimiter','tab');
    
    saveas(fig2,[SavePathPng fname '-ESR Spectrum' '_x-' num2str(PixX) '_y-' num2str(PixY) '_withBinning-' num2str(PixBin) '.png'],'png');
    saveas(fig2,[SavePathSvg fname '-ESR Spectrum' '_x-' num2str(PixX) '_y-' num2str(PixY) '_withBinning-' num2str(PixBin) '.svg'],'svg');
%     print(fig2,[SavePath fname '-ESR Spectrum' '_x-' num2str(PixX) '_y-' num2str(PixY) '_withBinning-' num2str(PixBin) '.pdf'],'-dpdf','-bestfit');
%     saveas(fig2,[SavePath fname '-ESR Spectrum' '_x-' num2str(PixX) '_y-' num2str(PixY) '_withBinning-' num2str(PixBin) '.emf'],'emf');
    
    MatOut2 = [Ftot Sp2 Sp2YData];
    if Fit_Value
        MatOut2 = [MatOut2 Sp2FitYData];
    end
    writematrix(MatOut2,[SavePathText fname '-ESR Spectrum' '_x-' num2str(PixX) '_y-' num2str(PixY) '_withBinning-' num2str(PixBin) '.txt'],'Delimiter','tab');
end

close(fig1);close(fig2);
%ajouter : si fit enclenché, exporte la figure avec le fit et les résultats du fit

end