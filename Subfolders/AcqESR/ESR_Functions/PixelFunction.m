function PixelFunction(hobject,eventdata)
global M Lum_Current
if sum(sum(M(:,:,end)))~=0
set(gcf,'WindowButtonMotionFcn',@mousemove)
set(gcf,'WindowButtonUpFcn',@mouseclick)
set(hobject,'ForegroundColor',[0,0,1]);
end

panel = guidata(gcbo);

CalibUnit_str = panel.calibunit.SelectedObject.String;
PixelCalib_nm = str2double(panel.pixelcalibvalue.String);
size_pix = PixelCalib_nm/1000; % in µm

if strcmp(CalibUnit_str,'nm')
    ind_calib_nm = 1;
else
    ind_calib_nm = 0;
end

function mousemove(object,eventdata) 
    panel = guidata(gcbo);
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
    C=get(panel.Axes1,'CurrentPoint'); % Point Coordinate
    if ind_calib_nm
        PixX_um=C(1,1);
        PixY_um=C(1,2);
        PixX = round(PixX_um/size_pix);
        PixY = round(PixY_um/size_pix);
    else
        PixX=round(C(1,1));
        PixY=round(C(1,2));
    end
    isPixInRange = CheckPixInRange(PixX,PixY);
    if isPixInRange
        UpdatePixPos(PixX,PixY);
        PrintESR(panel,Mat);      
        tag_fit = findobj('tag','Fit');
        Fit_Value = tag_fit.Value;
        if Fit_Value == 1
            panel = EraseFit();
            panel = CreateFit();
        end
    end
    
    set(gcf,'WindowButtonUpFcn',@mouseclick)
    guidata(gcbo,panel);
end

function mouseclick(object,eventdata)
    panel = guidata(gcbo);
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
    C=get(panel.Axes1,'CurrentPoint'); % Point Coordinate
    if ind_calib_nm
        PixX_um=C(1,1);
        PixY_um=C(1,2);
        PixX = round(PixX_um/size_pix);
        PixY = round(PixY_um/size_pix);
    else
        PixX=round(C(1,1));
        PixY=round(C(1,2));
    end    
    isPixInRange = CheckPixInRange(PixX,PixY);
    if isPixInRange
        UpdatePixPos(PixX,PixY);
        PrintESR(panel,Mat);
%         tag_fit = findobj('tag','Fit');
%         Fit_Value = tag_fit.Value;
%         if Fit_Value == 1
%             panel = EraseFit();
%             panel = CreateFit();
%         end
    end
    set(gcf,'WindowButtonMotionFcn','')
    set(gcf,'WindowButtonUpFcn','')
    set(hobject,'ForegroundColor',[1,0,0]);
    guidata(gcbo,panel);
end

end

