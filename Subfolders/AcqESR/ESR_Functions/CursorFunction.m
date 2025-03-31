function CursorFunction(hobject,eventdata)
h=guidata(gcbo); 
axes(h.Axes3);
if get(hobject,'Value')==1       
    dualcursor on;
    set(hobject,'ForegroundColor',[0,0,1]);
else
    dualcursor off;
    set(hobject,'ForegroundColor',[1,0,0]);
end
drawnow
end