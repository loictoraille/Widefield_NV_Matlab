function UpdateRF(~,~)
global RF_Address

panel=guidata(gcbo);

RFAlwaysON = panel.RFAlwaysON.Value;
MWPower = str2double(panel.MWPower.String);

SaveAcqParameters({{RFAlwaysON,'RFAlwaysON'}});

if RFAlwaysON
    STATE = 'ON';
else
    STATE = 'OFF';
end

SwitchGEN(STATE,MWPower);

end