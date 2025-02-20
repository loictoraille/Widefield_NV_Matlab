function value = convertToPixels(frequency,value)
% conversion MHz > pixels 
u=find(frequency>frequency(1)+value);
if ~isempty(u)
    value = u(1);
else
    value = length(frequency);
end
end