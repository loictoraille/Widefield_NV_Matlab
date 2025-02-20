function FitFunction(hobject,~)
global M Ftot

h=guidata(gcbo);

if get(hobject,'Value')==1
    set(hobject,'ForegroundColor',[0,1,0]);
    h = CreateFit();
else    
    h = EraseFit();
    set(hobject,'ForegroundColor',[1,0,0]);
end

guidata(gcbo,h)

end

