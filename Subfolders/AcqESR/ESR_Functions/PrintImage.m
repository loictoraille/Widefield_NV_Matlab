function PrintImage(ax,ImageMatrix,AOIParameters,MaxLum)

[x_axis,y_axis,x_label,y_label] = DefineAxes(AOIParameters);

axes(ax);
imagesc(x_axis,y_axis,ImageMatrix,[0,MaxLum]);
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


title(ax,['Max pixel value = ' num2str(round(max(max(ImageMatrix))))]);


end