function PowerVerdi(P)
%%%%
%Controls Verdi Power
%%%%
try
    Verd=serial('COM6','Baudrate',19200,'Databits',8,'Terminator','CR/LF');
    fopen(Verd);
    strP=['Power=',num2str(P)];
    fprintf(Verd,strP);
    fclose(Verd);
    delete(Verd);
    pause(0.5);
    
catch ME
    disp(ME);
end
end