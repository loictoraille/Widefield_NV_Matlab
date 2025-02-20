function CropFunction(hobject,eventdata)

if get(hobject,'Value')==1    
    set(hobject,'ForegroundColor',[0,1,0]);
else    
    set(hobject,'ForegroundColor',[1,0,0]);    
end

panel=guidata(gcbo);

set(panel.CropSelection,'ForegroundColor',[0,0,0]);

CropOrUpdateImage();

end