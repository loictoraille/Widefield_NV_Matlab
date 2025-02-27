function UpdateInputPiezo(X,Y,Z,Light,panel)

hX=findobj('tag','piezoX');
hY=findobj('tag','piezoY');
hZ=findobj('tag','piezoZ');
hlight=findobj('tag','piezoLightValue');

hX.String = num2str(X);
hY.String = num2str(Y);
hZ.String = num2str(Z);
hlight.String = num2str(Light);

if exist('panel','var')
    UpdateAcqParam(panel);
else
    UpdateAcqParam();
end

end

