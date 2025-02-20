
str = '';
s = '''';

C = who();

for i = 1:length(C)
    strtoadd = strcat(s,string(C{i}),s); 
    strtoadd = strcat(strtoadd,',');
    str = strcat(str,strtoadd);
end
    