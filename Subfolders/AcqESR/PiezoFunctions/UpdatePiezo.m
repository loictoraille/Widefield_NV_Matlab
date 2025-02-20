function UpdatePiezo(~,~)
global NI_card

h=findobj('tag','initpiezo');

[X_value, Y_value, Z_value, Light_value] = ReadPiezoInput();

if h.Value == 1
    
    hlightstate=findobj('tag','lightpiezo');
    if hlightstate.Value == 0
        Light_value = 0;
    end
    
    if exist('NI_card','var') && ~isempty('NI_card')
        CheckMaxAndWriteNI(X_value, Y_value, Z_value, Light_value)
    end
    
end

UpdateAcqParam();

end