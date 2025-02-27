function UpdatePiezo(~,~)
global NI_card

panel = guidata(gcbo);

[X_value, Y_value, Z_value, Light_value] = ReadPiezoInput();

Smart_PZ_Light_Laser_Write(panel);

UpdateAcqParam();

end