function UpdateInputPiezo(X,Y,Z,Light)

hX=findobj('tag','piezoX');
hY=findobj('tag','piezoY');
hZ=findobj('tag','piezoZ');
hlight=findobj('tag','piezoLightValue');

hX.String = num2str(X);
hY.String = num2str(Y);
hZ.String = num2str(Z);
hlight.String = num2str(Light);

PiezoX = X;
PiezoY = Y;
PiezoZ = Z;
PiezoLight = Light;

SaveAcqParameters({{PiezoX,'PiezoX'},{PiezoY,'PiezoY'},{PiezoZ,'PiezoZ'},{PiezoLight,'PiezoLight'}});

end

