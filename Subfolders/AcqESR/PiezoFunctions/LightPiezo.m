function LightPiezo(~,~)
global NI_card 

    h=findobj('tag','lightpiezo');
    
    if h.Value == 1
        h.ForegroundColor = [0,1,0];
    else
        h.ForegroundColor = [0,0,0];
    end
    
    UpdatePiezo();    

end