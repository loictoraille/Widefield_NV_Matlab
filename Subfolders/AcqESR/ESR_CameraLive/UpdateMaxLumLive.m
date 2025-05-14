function UpdateMaxLumLive(~,~)
global handleImage

if exist('handleImage','var') && ~isempty(handleImage)

    panel = guidata(gcbo);

    panel.MaxLumLive.Value = 1;

    MaxLum = str2double(panel.MaxLumLive.String);
    if MaxLum <= 0
        MaxLum = 1;
        panel.MaxLumLive.String = num2str(MaxLum);
    end

    panel.MaxLum.String = num2str(MaxLum);

    UpdateAcqParam();

    set(get(handleImage, 'Parent'), 'CLim', [0 MaxLum]);

end

end