function [X_value, Y_value, Z_value, Light_value] = ReadPiezoInput()
% the name is poorly chosen, this function is more specifically used to prevent crossing the piezo boundaries

hX=findobj('tag','piezoX');
hY=findobj('tag','piezoY');
hZ=findobj('tag','piezoZ');

X_value = str2double(hX.String);
Y_value = str2double(hY.String);
Z_value = str2double(hZ.String);

if X_value < -10
    X_value = -10;
end
if X_value > 10
    X_value = 10;
end

if Y_value < -10
    Y_value = -10;
end
if Y_value > 10
    Y_value = 10;
end

if Z_value < 0
    Z_value = 0;
end
if Z_value > 10
    Z_value = 10;
end

hX.String = num2str(X_value);
hY.String = num2str(Y_value);
hZ.String = num2str(Z_value);

hlight=findobj('tag','piezoLightValue');
Light_value = str2double(hlight.String);

% UpdateInputPiezo(X_value,Y_value,Z_value,Light_value);

% UpdateAcqParam();

end