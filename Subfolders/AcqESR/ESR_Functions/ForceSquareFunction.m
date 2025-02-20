function ForceSquareFunction(hobject,eventdata)
global M

sizeM = size(M);

h=guidata(gcbo);

x1 = str2num(h.X1.String);
y1 = str2num(h.Y1.String);
x2 = str2num(h.X2.String);
y2 = str2num(h.Y2.String);

lenx = x2-x1;leny = y2-y1;newlen = min(lenx,leny);

x_center = mean([x1,x2]);
y_center = mean([y1,y2]);

newx1 = max(1,floor(x_center-newlen/2));
newx2 = min(sizeM(2),floor(x_center+newlen/2));
newy1 = max(1,floor(y_center-newlen/2));
newy2 = min(sizeM(1),floor(y_center+newlen/2));

h.X1.String = num2str(newx1);
h.Y1.String = num2str(newy1);
h.X2.String = num2str(newx2);
h.Y2.String = num2str(newy2);

CropOrUpdateImage()
UpdateWHValues()

end