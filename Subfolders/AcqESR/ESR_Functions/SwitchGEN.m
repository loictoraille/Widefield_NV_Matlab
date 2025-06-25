function SwitchGEN(STATE,MWPower)
global MW_Gen TestWithoutHardware 
% The STATE variable combined with the RFAlwaysOn leads to a 
% weird way to do it, but it works

% if isempty(gcbo) %% to make it work from the start, but was deemed risky (frying wires)
%     panel=guihandles(gcf);
% else
%     panel=guidata(gcbo);
% end

if ~TestWithoutHardware
    
    if exist('MW_Gen','var') && any(isprop(MW_Gen,'Session'))
    else
        MW_Gen = Connect_RF();
    end
    WriteSMB(['POW ',num2str(MWPower),' DBm']);% update at each switch
    WriteSMB(['OUTP ' STATE]);
end

end

