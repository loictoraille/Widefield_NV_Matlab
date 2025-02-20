function panel = CreateFit()
global M Ftot

panel=guidata(gcbo);

if isfield(panel,'Crop') && panel.Crop.Value == 1
    sizeM = size(M);
    x1 = max(1,str2num(panel.X1.String));
    y1 = max(1,str2num(panel.Y1.String));
    x2 = min(sizeM(2),str2num(panel.X2.String));
    y2 = min(sizeM(1),str2num(panel.Y2.String));
    Mat = M(y1:y2,x1:x2,:);
else
    Mat = M;
end

load([getPath('Param') 'FitParameters.mat'],'FitParameters');
ReadFitParameters;

PixX = str2num(panel.PixX.String);
PixY = str2num(panel.PixY.String);
PixBin = str2num(panel.Bin_txt.String);

CalibUnit_str = panel.calibunit.SelectedObject.String;
PixelCalib_nm = str2double(panel.pixelcalibvalue.String);
size_pix = PixelCalib_nm/1000; % in µm

if strcmp(CalibUnit_str,'nm')
    ind_calib_nm = 1;
else
    ind_calib_nm = 0;
end

AllLim = {panel.Axes1.XLim(1),panel.Axes1.XLim(2),panel.Axes1.YLim(1),panel.Axes1.YLim(2)};
BinLim = floor(PixBin/2);

if ind_calib_nm
    for i=1:numel(AllLim)
        AllLim{i} = AllLim{i}/size_pix;
    end
end

if PixX>AllLim{1}+BinLim && PixX<AllLim{2}-BinLim && PixY>AllLim{3}+BinLim && PixY<AllLim{4}-BinLim
    %%Condition to be in panel image with bin width included
else
    if PixX-BinLim<AllLim{1}
        PixX=ceil(AllLim{1}+BinLim);
    end
    if PixX+BinLim>AllLim{2}
        PixX=floor(AllLim{2}-BinLim);
    end
    if PixY-BinLim<AllLim{3}
        PixY=ceil(AllLim{3}+BinLim);
    end
    if PixY+BinLim>AllLim{4}
        PixY=floor(AllLim{4}-BinLim);
    end
end

if PixX>AllLim{1}+BinLim && PixX<AllLim{2}-BinLim && PixY>AllLim{3}+BinLim && PixY<AllLim{4}-BinLim
    
    SPX = Ftot*1000; %in MHz
    SPXbin = SPX;
    
    SPY=squeeze(Mat(PixY,PixX,:));
    SPYbin=squeeze(mean(mean(Mat(PixY-BinLim:PixY+BinLim,PixX-BinLim:PixX+BinLim,:),1),2));
    
    if UsePstart
        if rem(NumPeaks,2) == 0 || NumPeaks == 1
            pStart = LoadPStart([getPath('Param') 'PstartFit'],NumPeaks/2,VarWidths,IsPair);
            pStart(1:NumPeaks) = pStart(1:NumPeaks)*pStart(end);
            pStart = pStart(1:end-1);% removing the baseline value for this fit method
            pStart = FromPairToPos(pStart).';
            pStartBin = LoadPStart([getPath('Param') 'PstartFitBin'],NumPeaks/2,VarWidths,IsPair);
            pStartBin(1:NumPeaks) = pStartBin(1:NumPeaks)*pStartBin(end);
            pStartBin = pStartBin(1:end-1);% removing the baseline value for this fit method
            pStartBin = FromPairToPos(pStartBin).';
        else
            disp('Cannot work with uneven number of peaks and UsePstart option for now');
            pStart = 0;pStartBin = 0;
        end
    else
        pStart = 0;pStartBin = 0;
    end
    
    switch FitMethod
        case 8 % Correlation method
%             MiddleFreq = OdmrCentre(SPX,SPY);
%             MiddleFreqBin = OdmrCentre(SPXbin,SPYbin);
            MiddleFreq = OdmrCentreV2(SPX,SPY);
            MiddleFreqBin = OdmrCentreV2(SPXbin,SPYbin);
        
        case 7 % Barycentre method
            MiddleFreq = GetBarycentre(SPX,SPY);
            MiddleFreqBin = GetBarycentre(SPXbin,SPYbin);
                   
        case 5 % Automatic advanced baseline removing 
    
            [FitPreset,FitResult,PFIT] = AutoFit(SPX,SPY,pStart,FitParameters);
            [FitPresetBin,FitResultBin,PFITBin] = AutoFit(SPXbin,SPYbin,pStartBin,FitParameters);
            
            renorm_pix = GetRenormValue(SPY);
            renorm_bin = GetRenormValue(SPYbin);
            
            FitPreset = FitPreset/renorm_pix;
            FitResult = FitResult/renorm_pix;
            FitPresetBin = FitPresetBin/renorm_bin;
            FitResultBin = FitResultBin/renorm_bin;
            
            if WithPreset == 1
                panel.l23=line('parent',panel.Axes2);
                panel.l33=line('parent',panel.Axes3);
                panel.l23.XData=SPX/1000;
                panel.l23.YData=FitPreset;
                panel.l33.XData=SPXbin/1000;
                panel.l33.YData=FitPresetBin;
                set(panel.l33,'Color','g');
                set(panel.l23,'Color','g');
            end
            
            panel.l34=line('parent',panel.Axes3);
            panel.l24=line('parent',panel.Axes2);
            
            panel.l34.XData=SPXbin/1000;
            panel.l34.YData=FitResultBin;
            
            panel.l24.XData=SPX/1000;
            panel.l24.YData=FitResult;
            
            set(panel.l34,'Color','r')
            set(panel.l24,'Color','r')
            
            StrFitResult1 = BuildStrResult(PFIT,1);
            StrFitResult2 = BuildStrResult(PFIT,2);
            StrFitResultBin1 = BuildStrResult(PFITBin,1);
            StrFitResultBin2 = BuildStrResult(PFITBin,2);
            
            text(0.05,0.99,StrFitResult1,'FontSize',10,'Tag','StrFitResult1','Units','Normalized','Parent',panel.Axes2,'Color','black');
            text(0.55,0.99,StrFitResult2,'FontSize',10,'Tag','StrFitResult2','Units','Normalized','Parent',panel.Axes2,'Color','black');
            text(0.05,0.99,StrFitResultBin1,'FontSize',10,'Tag','StrFitResultBin1','Units','Normalized','Parent',panel.Axes3,'Color','black');
            text(0.55,0.99,StrFitResultBin2,'FontSize',10,'Tag','StrFitResultBin2','Units','Normalized','Parent',panel.Axes3,'Color','black');
            
            %     guidata(gcbo,panel);
            
            if rem(NumPeaks,2) == 0
                WritePstartFit(PFIT, SPX, NumPeaks/2, IsPair, VarWidths,'jx');
                WritePstartFit(PFITBin, SPXbin, NumPeaks/2, IsPair, VarWidths,'jxBin');
            else
                disp('Cannot work with uneven number of peaks and UsePstart option for now');
            end
            
            [B,StrBField] = fittofield(PFITBin, NumComp, NumCompFittofield);
            
            xpos_val = -0.0045*length(StrBField)+0.4;
            text(xpos_val,-0.13,StrBField,'FontSize',16,'FontWeight','bold','Color','red','Tag','StrBField','Units','Normalized','Parent',panel.Axes3);
            
            guidata(gcbo,panel);
    end
    
    if FitMethod == 7 || FitMethod == 8
        
        panel.l24 = line(panel.Axes2, [MiddleFreq/1000 MiddleFreq/1000], get(panel.Axes2, 'YLim'), 'Color', 'red', 'LineWidth', 2);
        panel.l34 = line(panel.Axes3, [MiddleFreqBin/1000 MiddleFreqBin/1000], get(panel.Axes3, 'YLim'), 'Color', 'red', 'LineWidth', 2);
        
        StrMidFreq = ['Middle frequency = ' num2str(MiddleFreqBin/1000) ' GHz'];
        
        xpos_val = -0.0045*length(StrMidFreq)+0.4;
        text(xpos_val,-0.13,StrMidFreq,'FontSize',16,'FontWeight','bold','Color','red','Tag','StrBField','Units','Normalized','Parent',panel.Axes3);
        
    end
    
end
