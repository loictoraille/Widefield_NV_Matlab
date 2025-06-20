function str = formatDurationSimple(seconds)
    seconds = round(seconds);  % arrondi à la seconde la plus proche
    h = floor(seconds / 3600);
    m = floor(mod(seconds, 3600) / 60);
    s = mod(seconds, 60);

    parts = {};
    if h > 0
        parts{end+1} = sprintf('%dh', h);
    end
    if m > 0
        parts{end+1} = sprintf('%dmin', m);
    end
    if s > 0 || isempty(parts)  % toujours afficher quelque chose, même 0s
        parts{end+1} = sprintf('%ds', s);
    end

    str = strjoin(parts, ' ');
end
