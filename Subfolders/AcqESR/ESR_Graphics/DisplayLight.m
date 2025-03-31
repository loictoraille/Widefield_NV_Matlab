function DisplayLight(hobject,~)
global NI_card

DisplayLight = hobject.Value;
panel = guidata(gcbo);

load([getPath('Param') 'AcqParameters.mat']);

LightControl = 0;
if DisplayLight
% Check if a light control is connected
    if strcmp(AcqParameters.SetupType,"CEA") && isfield(panel,'UserData') && isfield(panel.UserData,'Betsa')
        LightControl = 1;
    end

    if strcmp(AcqParameters.SetupType,"ENS1") && exist('NI_card','var') && any(isprop(NI_card,'Running')) && ~isempty(daqlist)
        LightControl = 1;
    end
end

UpdateAcqParam();

[~,sizelevel] = size(AcqParameters.AOI.Width);
AOIParameters.AOI.Height = AcqParameters.AOI.Height(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.AOI.Width = AcqParameters.AOI.Width(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.PixelCalib_nm = AcqParameters.PixelCalib_nm;
AOIParameters.CalibUnit_str = AcqParameters.CalibUnit_str;

if LightControl == 0
    hobject.Value = 0;

    if isfield(panel,'UserData') && isfield(panel.UserData,'Lum_Current') && ~isempty(panel.UserData.Lum_Current)
        PrintImage(panel.Axes1,panel.UserData.Lum_Current,AOIParameters);
    end
else
    if isfield(panel,'UserData') && isfield(panel.UserData,'Lum_WithLightAndLaser') && ~isempty(panel.UserData.Lum_WithLightAndLaser)
        PrintImage(panel.Axes1,panel.UserData.Lum_WithLightAndLaser,AOIParameters);
    end
end


end