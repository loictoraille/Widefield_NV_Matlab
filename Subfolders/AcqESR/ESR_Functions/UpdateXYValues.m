function UpdateXYValues()
global M

sizeM = size(M);
panel=guidata(gcbo);

wmax = sizeM(2);hmax = sizeM(1);

x0 = str2double(panel.X0.String);
y0 = str2double(panel.Y0.String);
w = str2double(panel.W.String);
h = str2double(panel.H.String);

if x0<1;x0=1;end
if x0>wmax;x0=wmax;end
if y0<1;y0=1;end
if y0>hmax;y0=hmax;end

if x0+w/2>wmax;w=2*(wmax-x0);end
if y0+h/2>hmax;h=2*(hmax-y0);end

x1 = max(1,ceil(x0-w/2));
y1 = max(1,ceil(y0-w/2));
x2 = min(sizeM(2),floor(x0+w/2));
y2 = min(sizeM(1),floor(y0+h/2));

panel.X1.String = num2str(x1);
panel.Y1.String = num2str(y1);
panel.X2.String = num2str(x2);
panel.Y2.String = num2str(y2);

end