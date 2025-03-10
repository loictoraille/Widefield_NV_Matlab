function SwitchShutterBetsa(~,~)

panel = guidata(gcbo);

h=findobj('tag','shutterBetsa');

if isfield(panel,'UserData') && ~isempty(panel.UserData) && isfield(panel.UserData,'Betsa')

    Betsa = panel.UserData.Betsa;

    if h.Value == 1
        h.ForegroundColor = [0,1,0];
        writeline(Betsa, "RLY50"); % switches shutter toward light mode
    else
        h.ForegroundColor = [0,0,0];
        writeline(Betsa, "RLY51"); % switches shutter toward Raman mode
    end

else
    h.Value = 0;
end

end