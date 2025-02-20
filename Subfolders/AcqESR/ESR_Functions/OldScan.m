%%%Scan script
global M ObjCamera
Init_RF;%Calculate Frequency array Ftot and Initialize RF generator
[~,BitsPerPix]=ObjCamera.PixelFormat.GetBitsPerPixel();
[~,AOI]=ObjCamera.Size.AOI.Get;
ROIWidth=AOI.Width;
ROIHeight=AOI.Height;
[e,I]=ObjCamera.Memory.Allocate(ROIWidth,ROIHeight,BitsPerPix);
ObjCamera.Memory.SetActive(I);
[~,ExposureTime]=ObjCamera.Timing.Exposure.Get();
[~,FrameRate]=ObjCamera.Timing.Framerate.Get();
[~,PixelClock]=ObjCamera.Timing.PixelClock.Get();
M=zeros(ROIHeight,ROIWidth,NPoints);%Matrix used in main program
Pic=zeros(ROIHeight,ROIWidth,NPoints);%Matrix used in main program
if Read_Temp
T=zeros(AccNumber,2);
end
%Last=zeros(ROIHeight,ROIWidth,NPoints);
%Graphique;%GUI
%PowerVerdi(LaserPower);%532 nm Laser Power
%FindExposure();%Auto-Find camera exposure

ImageMatrix=TakeCameraImage;%Take Camera Image
axes(ax);imagesc(ImageMatrix,[0,4095]);axis('image');%Print Initial Camera Image
set(ax,'Tag','Axes1');%Necessary to rewrite tag of Axes1 after imagesc (I don't know why)

smb.Write('OUTP ON'); %RF Power ON
T=[];
if Read_Temp
    T_init=ReadTemp;
    set(Temp_handle,'String',num2str(T_init(1)));%T(Acc,1) to print Ta; T(Acc,2) to print Tb
end

for Acc=1:(AccNumber+99*ALIGN*AccNumber) %Loop on Accumulation number
    if RANDOM == 1    
        RandomPerm = randperm(length(Ftot));
    end
    for ii=1:NPoints %Loop on number of RF points
        
        strInfo=['Acc #', num2str(Acc),'/ Point ',num2str(ii),' sur ',num2str(NPoints)];
        set(TextInfo_Handle,'String',strInfo);%Display info on scan numbers
        if RANDOM == 1
        smb.Write(['FREQ ',num2str(Ftot(RandomPerm(ii),1)),'GHz'], Ftot(ii,1)*1e9);%Change RF freq.            
        else
        smb.Write(['FREQ ',num2str(Ftot(ii,1)),'GHz'], Ftot(ii,1)*1e9);%Change RF freq.
        end
        pause(0.01);
        ImageMatrix=TakeCameraImage;%Take Camera Image
        Pic(:,:,ii)=double(ImageMatrix);   
        if ALIGN == 1    
            M(:,:,ii)=double(ImageMatrix);            
        else            
            if RANDOM == 1                
            M(:,:,RandomPerm(ii))=(M(:,:,RandomPerm(ii))*(Acc-1)+double(ImageMatrix))/Acc;%Add image to the mean value of M
            else
            M(:,:,ii)=(M(:,:,ii)*(Acc-1)+double(ImageMatrix))/Acc;%Add image to the mean value of M
            end
        end
        drawnow;%Update GUI
        if StopButton.Value==1 %Check STOP button            
            break;
        end
        if Acc>1 && (PixX~=str2double(PixX_handle.String) || PixY~=str2double(PixY_handle.String)|| PixBin~=str2double(Bin_handle.String))
            UpdateGraphique;%Update ESR spectra if values have changed
            drawnow;%update GUI
        end
%         if Read_Temp
%         T=[T;ReadTemp()];
%         
% % figure(2),
% % plot(T(:,1))
% % figure(3),
% % plot(T(:,2))
%         end
    end
    if Read_Temp
        T(Acc,:)=ReadTemp();
        set(Temp_handle,'String',num2str(T(Acc,1)));%T(Acc,1) to print Ta; T(Acc,2) to print Tb
    end
    if ALIGN == 1
        SAVE = 0;
    end
    if SAVE == 1
        fullNameSave = ['./Data_Acq/' nomSave];
    else
        fullNameSave = ['./Data_Acq/' 'backup'];
    end
    save(fullNameSave,'M','Ftot','CenterF_GHz','Width_MHz','NPoints','Acc','MWPower','T','ExposureTime'...
        ,'FrameRate','PixelClock','RANDOM');
    drawnow;%update GUI
    UpdateGraphique;%Update ESR spectra
    
    %%To plot Mean Image (to see if image is moving)
    axes(ax);imagesc(mean(Pic,3),[0,4095]); axis('image'); 
    set(ax,'Tag','Axes1');    
    drawnow;%Update GUI
    
    if StopButton.Value==1%Check STOP Button
        break;
    end
end
smb.Write('OUTP OFF');%RF OFF
StopButton.Value=0;