function StepPiezo(axisName,direction)

panel = guidata(gcf);

switch upper(axisName)

    case 'X'

        value = str2double(panel.piezoX.String);
        range = str2double(panel.piezoRangeX.String);
        steps = str2double(panel.piezoStepX.String);

        delta = range / max(1,steps);

        panel.piezoX.String = num2str(value + direction*delta);

    case 'Y'

        value = str2double(panel.piezoY.String);
        range = str2double(panel.piezoRangeY.String);
        steps = str2double(panel.piezoStepY.String);

        delta = range / max(1,steps);

        panel.piezoY.String = num2str(value + direction*delta);

    case 'Z'

        value = str2double(panel.piezoZ.String);
        range = str2double(panel.piezoRangeZ.String);
        steps = str2double(panel.piezoStepZ.String);

        delta = range / max(1,steps);

        panel.piezoZ.String = num2str(value + direction*delta);

end

[X_value, Y_value, Z_value, Light_value] = ReadPiezoInput();

UpdateInputPiezo(X_value,Y_value,Z_value,Light_value);

Smart_PZ_Light_Laser_Write(panel);

end