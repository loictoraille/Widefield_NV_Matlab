function UpdateConfig(field, value)

filename = [getPath('Param') 'Config.txt'];

blocks = readConfigBlocks(filename);

blocks = updateBlock(blocks, field, value);

writeConfigBlocks(filename, blocks);

%%
function blocks = readConfigBlocks(filename)

fid = fopen(filename, 'r');
if fid == -1
    error('Could not open file %s', filename);
end

blocks = struct('key', {}, 'value', {}, 'sep', {});

i = 0;

while ~feof(fid)

    key = fgetl(fid);
    if ~ischar(key), break; end
    key = strtrim(key);

    if isempty(key)
        continue;
    end

    read_value = fgetl(fid);
    if ~ischar(read_value)
        read_value = '';
    end
    read_value = strtrim(read_value);

    sep = '';
    if ~feof(fid)
        sep = fgetl(fid); % blank line separator (kept as-is)
    end

    i = i + 1;

    blocks(i).key = key;
    blocks(i).value = read_value;
    blocks(i).sep = sep;

end

fclose(fid);

end

%%
function blocks = updateBlock(blocks, field, value)

for i = 1:numel(blocks)

    if contains(blocks(i).key, field)

        if isnumeric(value) || islogical(value)
            blocks(i).value = num2str(value);
        else
            blocks(i).value = char(value);
        end

        return;
    end

end

warning('Field "%s" not found in config file.', field);

end

%%

function writeConfigBlocks(filename, blocks)

fid = fopen(filename, 'wb');  % binary mode: no automatic newline translation
if fid == -1
    error('Could not open file %s for writing', filename);
end

CRLF = sprintf('\r\n');

fprintf(fid, '%s', CRLF);

for i = 1:numel(blocks)
    fprintf(fid, '%s%s', blocks(i).key,   CRLF);
    fprintf(fid, '%s%s', blocks(i).value, CRLF);
    % preserve original separator line behavior
    if ~isempty(blocks(i).sep)
        fprintf(fid, '%s%s', blocks(i).sep, CRLF);
    else
        fprintf(fid, '%s', CRLF);
    end
end

fclose(fid);
end

end