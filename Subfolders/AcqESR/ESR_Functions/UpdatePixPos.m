function UpdatePixPos(PixX,PixY)

panel=guidata(gcbo);

panel.PixX.String=num2str(PixX); 
panel.PixY.String=num2str(PixY);

end