function AutoMaxLumLive(~,~)
global handleImage

if exist('handleImage','var') && ~isempty(handleImage)

    panel = guidata(gcbo);

    panel.MaxLumLive.Value = 1;

    LumToPlot = handleImage.CData;

    if exist('LumToPlot','var')

        MaxLumVal = round(max(max(LumToPlot)));
        MaxLum = round(1.05*MaxLumVal);
        panel.MaxLum.String = num2str(MaxLum);
        panel.MaxLumLive.String = num2str(MaxLum);
        UpdateAcqParam();

        set(get(handleImage, 'Parent'), 'CLim', [0 MaxLum]);

    end

end


end