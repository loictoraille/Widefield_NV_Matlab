function figHandle = figure2(varargin)

MP = get(0,'MonitorPositions');
if size(MP, 1) == 1 % single monitor
    figH = figure(varargin{:});
else
    % catch creation of figure with disabled visibility
    indexVisible = find(strncmpi(varargin(1:2:end),'Vis',3));
    if ~isempty(indexVisible)
        paramVisible = varargin(indexVisible(end)+1);
    else
        paramVisible = get(0,'DefaultFigureVisible');
    end
    if MP(1,1) == 1
        Shift = MP(2,1:2);
    else
        Shift = MP(1,1:2);
    end
    figH = figure(varargin{:}, 'Visible', 'off');
    set(figH, 'Units', 'pixels');
    pos = get(figH, 'Position');
    set(figH, 'Position', [pos(1:2) + Shift, pos(3:4)], 'Visible', paramVisible);
end

if nargout ~= 0
    figHandle = figH;
end