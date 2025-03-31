function TurnOffUselessSettings(ListUselessSettings)
% All these settings are useless for Andor camera

for i = 1: numel(ListUselessSettings)
    eval(['tag = findobj(''tag'',''' ListUselessSettings{i} ''');']);
    tag.Visible = 0;
end


end