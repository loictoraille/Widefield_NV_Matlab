function UpdateRF(~,~)
global RF_Address

panel=guidata(gcbo);

RFAlwaysON = panel.RFAlwaysON.Value;

SaveAcqParameters({{RFAlwaysON,'RFAlwaysON'}});

if RFAlwaysON
    STATE = 'ON';
else
    STATE = 'OFF';
end

SwitchGEN(STATE);

end