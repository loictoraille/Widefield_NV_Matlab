%%Update ESR spectrum (binned+unbinned) at coordinate [PixX,PixY] from GUI values

PixX=str2double(panel.PixX.String);%Read x_Pixel from GUI
PixY=str2double(panel.PixY.String);%Read y_Pixel from GUI
PixBin=str2double(panel.Bin_txt.String);%Read Binning value from GUI

if PixX+floor(PixBin/2)>size(M,2) || PixY+floor(PixBin/2)>size(M,1) || PixX-floor((PixBin-1)/2)<0 || PixY-floor((PixBin-1)/2)<0
    PixBin=1;
    PixX=floor(size(M,2)/2);
    PixY=floor(size(M,1)/2);
    panel.PixX.String = num2str(PixX);
    panel.PixY.String = num2str(PixY);
    panel.Bin_txt.String = num2str(PixBin);
end

Sp1=M(PixY,PixX,:);%ESR spectrum - no binning - at [PixX,PixY] from Last.
Sp2=mean(mean(M(PixY-floor((PixBin-1)/2):PixY+floor(PixBin/2),PixX-floor((PixBin-1)/2):PixX+floor(PixBin/2),:),1),2);%Binned ESR spectrum  at [PixX,PixY] form Last
l21 = panel.l21;
l31 = panel.l31;
l21.XData=Ftot;
l31.XData=Ftot;
% l21.YData=squeeze(Sp1)./mean(squeeze(Sp1(1:5)));%Update Line l21 with unbinned ESR
% l31.YData=squeeze(Sp2)./mean(squeeze(Sp2(1:5)));%Update Line l31 with binned ESR
l21.YData=squeeze(Sp1);%Update Line l21 with unbinned ESR
l31.YData=squeeze(Sp2);%Update Line l31 with binned ESR
ax3=panel.Axes3;
% lum1_tag = panel.lum1text;
lum1_tag = findobj('tag','lum1text');
delete(lum1_tag);
text(1.02,0.87,num2str(round(GetRenormValue(squeeze(Sp1)))),'FontSize',12,'Tag','lum1text','Units','Normalized','Parent',ax3,'Color','black');
ax2=panel.Axes2;
% lum0_tag = panel.lum0text;
lum0_tag = findobj('tag','lum0text');
delete(lum0_tag);
text(1.02,0.87,num2str(round(GetRenormValue(squeeze(Sp2)))),'FontSize',12,'Tag','lum0text','Units','Normalized','Parent',ax2,'Color','black');
