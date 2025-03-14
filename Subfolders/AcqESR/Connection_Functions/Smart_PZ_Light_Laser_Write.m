function Tension4 = Smart_PZ_Light_Laser_Write(panel)
% function that uses the NI card and the com port to control piezo, light and laser
% optionally return Tension4, the fourth tension value of the NI card, for ease of use in PerformAlignPiezo sequence

load([getPath('Param') 'AcqParameters.mat']);

X_value = AcqParameters.PiezoX;
Y_value = AcqParameters.PiezoY;
Z_value = AcqParameters.PiezoZ;
Light_value = AcqParameters.PiezoLight;

piezo_state = panel.switchpiezo.Value;
light_state = panel.light.Value;
laser_state = panel.shutterlaser.Value;

if piezo_state
    piezo_X = X_value;piezo_Y = Y_value;piezo_Z = Z_value;
else
    piezo_X = 0;piezo_Y = 0;piezo_Z = 0;
end

if strcmp(AcqParameters.SetupType,"CEA")
    if laser_state
        piezo_4 = 5;
    else
        piezo_4 = 0;
    end
end

if strcmp(AcqParameters.SetupType,"ENS1")
    if light_state
        piezo_4 = Light_value;
    else
        piezo_4 = 0;
    end
    if laser_state
        panel.shutterlaser.Value = 0;
        panel.shutterlaser.ForegroundColor = [0,0,0];
    end
end

CheckMaxAndWriteNI(piezo_X, piezo_Y, piezo_Z, piezo_4);

if strcmp(AcqParameters.SetupType,"CEA") && isfield(panel,'UserData') && isfield(panel.UserData,'Betsa')
    Betsa = panel.UserData.Betsa;
    if light_state
        writeline(Betsa, "RLY61"); % turns reflected light on
        writeline(Betsa, "RLY50"); % switches shutter toward light mode
    else
        writeline(Betsa, "RLY60"); % turns reflected light off
        writeline(Betsa, "RLY51"); % switches shutter toward Raman mode
    end
end

Tension4 = piezo_4;

end