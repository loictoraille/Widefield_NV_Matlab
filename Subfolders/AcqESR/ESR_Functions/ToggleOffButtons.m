function h = ToggleOffButtons()
global M Ftot Lum_Current

h=guidata(gcbo);

hMaxLum = findobj('tag','MaxLum');
MaxLum = str2double(hMaxLum.String);

% Fit Button

hobjectfit = findobj('tag','Fit');
if get(hobjectfit,'Value')==1
    set(hobjectfit,'Value',0);
    set(hobjectfit,'ForegroundColor',[1,0,0]);    
    h = EraseFit();
end

% Compare Button
hobjectcomp = findobj('tag','comp');
if get(hobjectcomp,'Value')==1
    set(hobjectcomp,'Value',0);
    set(hobjectcomp,'ForegroundColor',[1,0,0]);   
    delete(h.l32)
    delete(h.l22)
    lum2_tag = findobj('tag','lum2text');
    delete(lum2_tag)
    lum02_tag = findobj('tag','lum02text');
    delete(lum02_tag);
end

% Pix Button
hobjectcpix = findobj('tag','Pix');
if get(hobjectcpix,'Value')==1
    set(hobjectcpix,'Value',0);
    set(hobjectcpix,'ForegroundColor',[1,0,0]);    
    set(gcf,'WindowButtonMotionFcn','');
    set(gcf,'WindowButtonUpFcn','');
end

% Cursors Button
hobjectcursor = findobj('tag','Cursor');
if numel(hobjectcursor) == 3 % the lines created seem to have the same tag as the button    
    axes(h.Axes3);
    dualcursor off;
    hobjectcursor = findobj('tag','Cursor');
    set(hobjectcursor,'Value',0);
    set(hobjectcursor,'ForegroundColor',[1,0,0]);
end

% Crop Button
hobjectcrop = findobj('tag','Crop');
 if ~isempty(hobjectcrop) && get(hobjectcrop,'Value')==1
    set(hobjectcrop,'Value',0);
    set(hobjectcrop,'ForegroundColor',[1,0,0]);
    load([getPath('Param') 'FileInfo.mat'],'-mat','fname','pname');
    load([pname fname '.mat'],'AcqParameters');
    ax = h.Axes1;
    
    if exist('Lum_Current','var')
        ImageMatrix = Lum_Current;
    else
        ImageMatrix=M(:,:,1);
    end
    PrintImage(ax,ImageMatrix,AcqParameters,MaxLum)
 end

end