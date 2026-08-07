
function Update_Tension()

panel=guidata(gcbo);

BxCoil = str2double(panel.BxCoil.String);
ByCoil = str2double(panel.ByCoil.String);
BzCoil = str2double(panel.BzCoil.String);
XcoilCalib = str2double(panel.XcoilCalib.String);
YcoilCalib = str2double(panel.YcoilCalib.String);
ZcoilCalib = str2double(panel.ZcoilCalib.String);

new_B_norm = sqrt(BxCoil^2+ByCoil^2+BzCoil^2);

panel.BnormCoil.String = num2str(round(new_B_norm*100)/100);

if panel.Bbutton.Value == 1    
Tension_x = BxCoil/XcoilCalib;
Tension_y = ByCoil/YcoilCalib;
Tension_z = BzCoil/ZcoilCalib;
Monitor = -10; % enabling coaxial cable is inverted
    
else
Tension_x = 0; 
Tension_y = 0;  
Tension_z = 0; 
Monitor = 0;
end

if isfield(panel,'UserData') && isfield(panel.UserData,'MCC')
    MCC = panel.UserData.MCC;
    write(MCC,[Tension_x Tension_y Tension_z Monitor]);
    panel.Vxc.String = ['VxCoil = ' num2str(floor(Tension_x*100)/100) ' V'];
    panel.Vyc.String = ['VyCoil = ' num2str(floor(Tension_y*100)/100) ' V'];
    panel.Vzc.String = ['VzCoil = ' num2str(floor(Tension_z*100)/100) ' V'];
    if Monitor == -10
        panel.Bbutton.String = 'ON';
        panel.Bbutton.ForegroundColor = 'b';
        panel.CoilState.String = 'ON';
        panel.CoilState.ForegroundColor = 'b';
    else
        panel.Bbutton.String = 'OFF';
        panel.Bbutton.ForegroundColor = 'r';
        panel.CoilState.String = 'OFF';
        panel.CoilState.ForegroundColor = 'r';
    end
end

%%

if panel.Bbutton.Value == 1
    B_state = 'ON';
else
    B_state = 'OFF';
end
Bname_User1 = panel.Bname_User1.String;
Bname_User2 = panel.Bname_User2.String;

SaveAcqParameters({{BxCoil,'BxCoil'},{ByCoil,'ByCoil'},{BzCoil,'BzCoil'}, ...
    {XcoilCalib,'XcoilCalib'},{YcoilCalib,'YcoilCalib'},{ZcoilCalib,'ZcoilCalib'}...
    {B_state,'B_state'},{Bname_User1,'Bname_User1'},{Bname_User2,'Bname_User2'},...
    });

end