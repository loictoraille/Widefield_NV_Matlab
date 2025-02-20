function PrintImage(ax,ImageMatrix,AOIParameters)
global CameraType

if strcmp(CameraType,'Andor')
    maxLum = 65535;
else
    maxLum = 4095;
end

[x_axis,y_axis,x_label,y_label] = DefineAxes(AOIParameters);

axes(ax);
imagesc(x_axis,y_axis,ImageMatrix,[0,maxLum]);
axis('image');%Print Camera Image

if isprop(ax,'Toolbar')
    ax.Toolbar.Visible = 'off';
end
xlabel(x_label);
ylabel(y_label);
c = colorbar;
c.Label.FontSize = 11;
c.Label.String = 'Photoluminescence';
set(ax,'Tag','Axes1');%Necessary to rewrite tag of Axes1 after imagesc (I don't know why)

end