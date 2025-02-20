function FuncInputPixels()
global M Lum_Current

panel=guidata(gcbo);
PixX = str2num(panel.PixX.String);  
PixY = str2num(panel.PixY.String);         
Fit_Value = panel.Fit.Value; 

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

[PixX,PixY] = RestrictPixPosToEdges(PixX,PixY);
UpdatePixPos(PixX,PixY);

PrintESR(panel,Mat);

if Fit_Value == 1
    panel = EraseFit();
    panel = CreateFit();
    guidata(gcbo,panel);
end