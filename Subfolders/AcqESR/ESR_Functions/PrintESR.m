function PrintESR(panel,MatIn)
global Ftot 

Cursor_Value = panel.Cursor.Value;
RefMWOff = str2double(panel.RefMWOff.String);

PixX = str2num(panel.PixX.String);    
PixY = str2num(panel.PixY.String);  
PixBin = str2num(panel.Bin_txt.String);

CalibUnit_str = panel.calibunit.SelectedObject.String;
PixelCalib_nm = str2double(panel.pixelcalibvalue.String);
size_pix = PixelCalib_nm/1000; % in µm

if strcmp(CalibUnit_str,'nm')
    ind_calib_nm = 1;
else
    ind_calib_nm = 0;
end

AllLim = {panel.Axes1.XLim(1),panel.Axes1.XLim(2),panel.Axes1.YLim(1),panel.Axes1.YLim(2)};
BinLim = floor(PixBin/2);

if ind_calib_nm
    for i=1:numel(AllLim)
        AllLim{i} = AllLim{i}/size_pix;
    end
end

%case single pixel

%we normalize with the five first values and the last five values

Sp1=MatIn(PixY,PixX,:);
renorm1_value = GetRenormValue(squeeze(Sp1));
panel.l21.XData=Ftot;panel.l21.YData=squeeze(Sp1)./renorm1_value;
lum1_value = renorm1_value;

% if ind_calib_nm
% title(panel.Axes1,['(X,Y,I)=(',num2str(PixX),' pixel,',num2str(PixY),' pixel,',num2str(round(lum1_value)),')']); %Spanelow coordinates in panel title
% else
% title(panel.Axes1,['(X,Y,I)=(',num2str(PixX),',',num2str(PixY),',',num2str(round(lum1_value)),')']); %Spanelow coordinates in panel title
% end

panel.lum1text.String = num2str(round(lum1_value));

%case binning

if PixX>AllLim{1}+BinLim && PixX<AllLim{2}-BinLim && PixY>AllLim{3}+BinLim && PixY<AllLim{4}-BinLim
    %%Condition to be in panel image with bin width included
else
    if PixX-BinLim<AllLim{1}
        PixX=ceil(AllLim{1}+BinLim);
    end
    if PixX+BinLim>AllLim{2}
        PixX=floor(AllLim{2}-BinLim);
    end
    if PixY-BinLim<AllLim{3}
        PixY=ceil(AllLim{3}+BinLim);
    end
    if PixY+BinLim>AllLim{4}
        PixY=floor(AllLim{4}-BinLim);
    end
end

if PixX>AllLim{1}+BinLim && PixX<AllLim{2}-BinLim && PixY>AllLim{3}+BinLim && PixY<AllLim{4}-BinLim
    % check again in case modifications were not enough (rectangle ROI for example)
    Sp2=mean(mean(MatIn(PixY-BinLim:PixY+BinLim,PixX-BinLim:PixX+BinLim,:),1),2);
    renorm0_value =  GetRenormValue(squeeze(Sp2));
    lum0_value = renorm0_value;
    panel.l31.XData=Ftot;panel.l31.YData=squeeze(Sp2)./renorm0_value;
    panel.lum0text.String = num2str(round(lum0_value));
    if Cursor_Value == 1
        axes(panel.Axes3);
        val=dualcursor(panel.Axes3);
        if ~isempty(val)
            dualcursor([val(1) val(3)]);
        end
    end
end

end