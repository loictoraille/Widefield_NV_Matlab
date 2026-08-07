function UpdatePiezo(~,~)

panel = guidata(gcbo);

[X_value, Y_value, Z_value, Light_value] = ReadPiezoInput();

UpdateInputPiezo(X_value,Y_value,Z_value,Light_value);

Smart_PZ_Light_Laser_Write(panel);

end