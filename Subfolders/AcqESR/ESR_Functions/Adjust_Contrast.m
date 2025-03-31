

f1=2.873;
f2=2.928;
% f3=2.846;
% f4=2.873;
PixX=79;
PixY=73;
Acc=5;
PixBin=10;

while 1==1

C1=[];C2=[];C3=[];C4=[];
Pref=0;P1=0;P2=0;P3=0;P4=0;
WriteSMB('POW 25 DBm');

for ii=1:Acc
WriteSMB('OUTP OFF');
ImageMatrix=TakeCameraImage;
Pref=Pref+mean(mean(double(ImageMatrix(PixY-floor((PixBin-1)/2):PixY+floor(PixBin/2),PixX-floor((PixBin-1)/2):PixX+floor(PixBin/2)))));

WriteSMB('OUTP ON');

WriteSMB(['FREQ ',num2str(f1),'GHz']);%Change RF freq.
pause(0.01);
ImageMatrix=TakeCameraImage;
P1=P1+mean(mean(double(ImageMatrix(PixY-floor((PixBin-1)/2):PixY+floor(PixBin/2),PixX-floor((PixBin-1)/2):PixX+floor(PixBin/2)))));

WriteSMB(['FREQ ',num2str(f2),'GHz']);%Change RF freq.
pause(0.01);
ImageMatrix=TakeCameraImage;
P2=P2+mean(mean(double(ImageMatrix(PixY-floor((PixBin-1)/2):PixY+floor(PixBin/2),PixX-floor((PixBin-1)/2):PixX+floor(PixBin/2)))));

% WriteSMB(['FREQ ',num2str(f3),'GHz']);%Change RF freq.
% pause(0.01);
% ImageMatrix=TakeCameraImage;
% P3=P3+mean(mean(double(ImageMatrix(PixY-floor((PixBin-1)/2):PixY+floor(PixBin/2),PixX-floor((PixBin-1)/2):PixX+floor(PixBin/2)))));
% 
% WriteSMB(['FREQ ',num2str(f4),'GHz']);%Change RF freq.
% pause(0.01);
% ImageMatrix=TakeCameraImage;
% P4=P4+mean(mean(double(ImageMatrix(PixY-floor((PixBin-1)/2):PixY+floor(PixBin/2),PixX-floor((PixBin-1)/2):PixX+floor(PixBin/2)))));


C1=[C1,100*(1-P1/Pref)];
C2=[C2,100*(1-P2/Pref)];
% C3=[C3,100*(1-P3/Pref)];
% C4=[C4,100*(1-P4/Pref)];
figure(10),hold off
plot(C1),hold on
plot(C2),...
% plot(C3),plot(C4)
% ylim([0,6])
drawnow
end
pause(1)
end
