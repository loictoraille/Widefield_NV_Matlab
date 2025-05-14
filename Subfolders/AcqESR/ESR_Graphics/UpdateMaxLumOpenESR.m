function UpdateMaxLumOpenESR(~,~)

panel = guidata(gcbo);

MaxLum = str2double(panel.MaxLum.String);
if MaxLum <= 0
    MaxLum = 1;
    panel.MaxLum.String = num2str(MaxLum);
end

AOIParameters = panel.UserData.AOIParameters;

UpdateMaxLumFunc(panel,AOIParameters);

end