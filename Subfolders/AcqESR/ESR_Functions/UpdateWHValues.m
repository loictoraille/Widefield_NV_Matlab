function UpdateWHValues()
global M

sizeM = size(M);
panel=guidata(gcbo);

x1 = max(1,str2num(panel.X1.String));
y1 = max(1,str2num(panel.Y1.String));
x2 = min(sizeM(2),str2num(panel.X2.String));
y2 = min(sizeM(1),str2num(panel.Y2.String));

x0 = floor(mean([x1,x2]));
y0 = floor(mean([y1,y2]));
w = x2-x1+1;
h = y2-y1+1;

panel.X0.String = num2str(x0);
panel.Y0.String = num2str(y0);
panel.W.String = num2str(w);
panel.H.String = num2str(h);

end