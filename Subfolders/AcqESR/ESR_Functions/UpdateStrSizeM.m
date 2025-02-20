function UpdateStrSizeM(ROIWidth,ROIHeight,Ftot)

panel=guidata(gcbo);

strSizeM = ['Size of M : (w,h,v) = (' num2str(ROIWidth) ',' num2str(ROIHeight) ',' num2str(length(Ftot)) ')'];
panel.sizeM.String = strSizeM;

end