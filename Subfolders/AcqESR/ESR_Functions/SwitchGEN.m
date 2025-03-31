function SwitchGEN(STATE)
global smb TestWithoutHardware RF_Address
% The STATE variable combined with the RFAlwaysOn leads to a 
% weird way to do it, but it works

% if isempty(gcbo) %% to make it work from the start, but was deemed risky (frying wires)
%     panel=guihandles(gcf);
% else
%     panel=guidata(gcbo);
% end

if ~TestWithoutHardware
    
    if exist('smb','var') && any(isprop(smb,'Session'))
    else
        smb = Connect_RF();
    end
    WriteSMB(['OUTP ' STATE]);
end

end

