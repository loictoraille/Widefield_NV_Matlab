function UpdateFit(~,~)

UpdateFitParam();

panel = guidata(gcbo);

if panel.Fit.Value == 1
    panel = EraseFit();
    panel = CreateFit();
    guidata(gcbo,panel);
end

end
