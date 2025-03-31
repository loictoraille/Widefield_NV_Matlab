
CalibDist = 0;
%% Visualize fit results from a FitESR treated data file
load([pname fname]);
[h,w,~] = size(ESRMatrix);
[x_start, y_start, x_stoptoend, y_stoptoend, wcrop, hcrop] = Cropping(w,h,Cropping_Coord);
% close(figField);

if ~exist('IsPair')
    IsPair = 1;
end
if ~exist('RemPositive')
    RemPositive = 0;
end

%% Plot fit results

figVisu = figure('Name','Visualisation Fit','Position',[700 350 1000 400]);%create figure handle
figVisu.WindowState = 'maximized';

tgroup = uitabgroup(figVisu);
tab1 = uitab(tgroup,'Title','Visu');
tgroup.SelectedTab = tab1;

TabVisuFit;

Total_handles=guihandles(figVisu);
guidata(figVisu,Total_handles);

%% Update Graphique
colorbarmin = 0.99;
colorbarmax = 1.015;

Start_VisuFit;
drawnow;

PixObject = findobj('Tag','PixVisuFit');
PixObject.Value = 1;
set(PixObject,'ForegroundColor',[0,0,1]);
set(gcf,'WindowButtonMotionFcn', @(object,eventdata) mousemove(object,eventdata,ESRMatrix,x_start,y_start,x_stoptoend,y_stoptoend,v_MHz,FitTot,BinThr,VarWidths,NumComp,IsPair,Smoothing_Factor,Detrending_Factor,ClearFFT,RemPositive, FitParameters))

function mousemove(object,eventdata,ESRMatrix,x_start,y_start,x_stoptoend,y_stoptoend,v_MHz,FitTot,BinThr,VarWidths,NumComp,IsPair,Smoothing_Factor,Detrending_Factor,ClearFFT,RemPositive,FitParameters)   
    PixObject = findobj('Tag','PixVisuFit');
    if PixObject.Value == 1
        h=guidata(gcbo);
        C=get(h.EsrImg,'CurrentPoint'); % Point Coordinate
        PixX=floor(C(1,1));
        PixY=floor(C(1,2));
        if PixX>h.EsrImg.XLim(1) && PixX<h.EsrImg.XLim(2) && PixY>h.EsrImg.YLim(1) && PixY<h.EsrImg.YLim(2) %%Condition to be in the image
            title(h.EsrImg,['(X,Y,I)=(',num2str(PixX),',',num2str(PixY),',',num2str(round(GetRenormValue(ESRMatrix(PixY,PixX,:)))),')'],'FontSize',10); %Show coordinate in the title
            jx = squeeze(FitTot(PixY,PixX,:));
            [spectre,~] = extractEsrThr(ESRMatrix, PixX+x_start-1, PixY+y_start-1, BinThr);
            spectre = PerformTreatmentOperations(spectre, v_MHz, Smoothing_Factor, Detrending_Factor, ClearFFT, RemPositive);
            updateSpectra(v_MHz,jx, spectre, VarWidths, NumComp, IsPair,FitParameters);
            updtEsrImg(ESRMatrix, v_MHz, PixX, PixY, x_start, y_start, x_stoptoend, y_stoptoend);  
            set(gcf,'WindowButtonUpFcn', @(object,eventdata) mouseclick(object,eventdata,ESRMatrix,x_start,y_start,x_stoptoend,y_stoptoend,v_MHz,FitTot,BinThr,VarWidths,NumComp,IsPair,Smoothing_Factor,Detrending_Factor,ClearFFT,RemPositive, FitParameters))
            guidata(gcbo,h)
        else
            title(h.EsrImg,'')
        end
    end
end
function mouseclick(object,eventdata,ESRMatrix,x_start,y_start,x_stoptoend,y_stoptoend,v_MHz,FitTot,BinThr,VarWidths,NumComp,IsPair,Smoothing_Factor,Detrending_Factor,ClearFFT,RemPositive,FitParameters)
    PixObject = findobj('Tag','PixVisuFit');
    h=guidata(gcbo);
    C=get(h.EsrImg,'CurrentPoint'); % Point Coordinate
    PixX=floor(C(1,1));
    PixY=floor(C(1,2));
    if PixX>h.EsrImg.XLim(1) && PixX<h.EsrImg.XLim(2) && PixY>h.EsrImg.YLim(1) && PixY<h.EsrImg.YLim(2) %%COndition to be in the image
        title(h.EsrImg,['(X,Y,I)=(',num2str(PixX),',',num2str(PixY),',',num2str(round(GetRenormValue(ESRMatrix(PixY,PixX,:)))),')']); %Show coordinate in the title
        jx = squeeze(FitTot(PixY,PixX,:));
        [spectre,~] = extractEsrThr(ESRMatrix, PixX+x_start-1, PixY+y_start-1, BinThr);
        spectre = PerformTreatmentOperations(spectre, v_MHz, Smoothing_Factor, Detrending_Factor, ClearFFT, RemPositive);
        updateSpectra(v_MHz,jx, spectre, VarWidths, NumComp, IsPair,FitParameters);
        updtEsrImg(ESRMatrix, v_MHz, PixX, PixY, x_start, y_start, x_stoptoend, y_stoptoend); 
        set(gcf,'WindowButtonMotionFcn','')
        set(gcf,'WindowButtonUpFcn','')
        set(PixObject,'ForegroundColor',[1,0,0],'Value',0);
        guidata(gcbo,h)            
    end
end