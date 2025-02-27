function AutofocusPiezo(~,~)

h=guidata(gcbo);%handles of the graphical objects

if ~h.acqcont.Value
    FuncAutoFocusPiezo(h);
end

end