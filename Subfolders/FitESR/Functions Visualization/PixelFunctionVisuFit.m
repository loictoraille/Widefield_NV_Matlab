function PixelFunctionVisuFit(hobject,eventdata,ESRMatrix,x_start,y_start,x_stoptoend,y_stoptoend,v_MHz,FitTot,BinThr,VarWidths,NumComp,IsPair,Smoothing_Factor,Detrending_Factor,ClearFFT,RemPositive, FitParameters)
if sum(sum(ESRMatrix(:,:,end)))~=0
set(gcf,'WindowButtonMotionFcn', @(object,eventdata) mousemove(object,eventdata,ESRMatrix,x_start,y_start,x_stoptoend,y_stoptoend,v_MHz,FitTot,BinThr,VarWidths,NumComp,IsPair,Smoothing_Factor,Detrending_Factor,ClearFFT,RemPositive, FitParameters))
set(gcf,'WindowButtonUpFcn', @(object,eventdata) mouseclick(object,eventdata,ESRMatrix,x_start,y_start,x_stoptoend,y_stoptoend,v_MHz,FitTot,BinThr,VarWidths,NumComp,IsPair,Smoothing_Factor,Detrending_Factor,ClearFFT,RemPositive, FitParameters))
set(hobject,'ForegroundColor',[0,0,1]);
end

function mousemove(object,eventdata,ESRMatrix,x_start,y_start,x_stoptoend,y_stoptoend,v_MHz,FitTot,BinThr,VarWidths,NumComp,IsPair,Smoothing_Factor,Detrending_Factor,ClearFFT,RemPositive, FitParameters)   
        h=guidata(gcbo);
        C=get(h.EsrImg,'CurrentPoint'); % Point Coordinate
        PixX=floor(C(1,1));
        PixY=floor(C(1,2));
        if PixX>h.EsrImg.XLim(1) && PixX<h.EsrImg.XLim(2) && PixY>h.EsrImg.YLim(1) && PixY<h.EsrImg.YLim(2) %%COndition to be in the image
            M = ESRMatrix;
            title(h.EsrImg,['(X,Y,I)=(',num2str(PixX),',',num2str(PixY),',',num2str(round(mean(M(PixY,PixX,1:5)))),')']); %Show coordinate in the title
            jx = squeeze(FitTot(PixY,PixX,:));
            [spectre,~] = extractEsrThr(ESRMatrix, PixX+x_start-1, PixY+y_start-1, BinThr);
            spectre = PerformTreatmentOperations(spectre, v_MHz, Smoothing_Factor, Detrending_Factor, ClearFFT, RemPositive);
            updateSpectra(v_MHz,jx, spectre, VarWidths, NumComp, IsPair, FitParameters);
            updtEsrImg(ESRMatrix, v_MHz, PixX, PixY, x_start, y_start, x_stoptoend, y_stoptoend);  
            set(gcf,'WindowButtonUpFcn', @(object,eventdata) mouseclick(object,eventdata,ESRMatrix,x_start,y_start,x_stoptoend,y_stoptoend,v_MHz,FitTot,BinThr,VarWidths,NumComp,IsPair,Smoothing_Factor,Detrending_Factor,ClearFFT,RemPositive, FitParameters))
            guidata(gcbo,h)
        else
            title(h.EsrImg,'')
        end
%         drawnow;
end
    function mouseclick(object,eventdata,ESRMatrix,x_start,y_start,x_stoptoend,y_stoptoend,v_MHz,FitTot,BinThr,VarWidths,NumComp,IsPair,Smoothing_Factor,Detrending_Factor,ClearFFT,RemPositive, FitParameters)
        h=guidata(gcbo);
        C=get(h.EsrImg,'CurrentPoint'); % Point Coordinate
        PixX=floor(C(1,1));
        PixY=floor(C(1,2));
        if PixX>h.EsrImg.XLim(1) && PixX<h.EsrImg.XLim(2) && PixY>h.EsrImg.YLim(1) && PixY<h.EsrImg.YLim(2) %%COndition to be in the image
            title(h.EsrImg,['(X,Y,I)=(',num2str(PixX),',',num2str(PixY),',',num2str(round(mean(ESRMatrix(1:5)))),')']); %Show coordinate in the title
            jx = squeeze(FitTot(PixY,PixX,:));
            [spectre,~] = extractEsrThr(ESRMatrix, PixX+x_start-1, PixY+y_start-1, BinThr);
            spectre = PerformTreatmentOperations(spectre, v_MHz, Smoothing_Factor, Detrending_Factor, ClearFFT, RemPositive);
            updateSpectra(v_MHz,jx, spectre, VarWidths, NumComp, IsPair, FitParameters);
            updtEsrImg(ESRMatrix, v_MHz, PixX, PixY, x_start, y_start, x_stoptoend, y_stoptoend); 
            set(gcf,'WindowButtonMotionFcn','')
            set(gcf,'WindowButtonUpFcn','')
            set(hobject,'ForegroundColor',[1,0,0]);
            guidata(gcbo,h)            
        end
%         drawnow;
    end
end

