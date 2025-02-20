function T=ReadTemp()
Lakeshore=serial('COM6','Baudrate',57600,'Databits',7,'Parity','odd','Terminator','CR/LF');
fopen(Lakeshore);

ReadTempA='KRDG?A';
fprintf(Lakeshore,ReadTempA);
fscanf(Lakeshore);%dummy because first one doesn't work
fprintf(Lakeshore,ReadTempA);
Ta=fscanf(Lakeshore);
pause(0.01)
% INTYPEB='INTYPE B,1,0,0,0,1'; % INTYPEB='INTYPE B,4,0,0,1,1';%
% fprintf(Lakeshore,INTYPEB);
% pause(0.5);
% INCRVB='INCRV B,2'; %INCRVB='INCRV B,13';% 
% fprintf(Lakeshore,INCRVB);
% pause(0.5);
% ReadTempB='KRDG?B';
% fprintf(Lakeshore,ReadTempB);
% Tbdiode=fscanf(Lakeshore);
% 
% INTYPEB='INTYPE B,4,0,0,1,1';
% fprintf(Lakeshore,INTYPEB);
% pause(0.5);
% INCRVB='INCRV B,13';%
% fprintf(Lakeshore,INCRVB);
% pause(2);
ReadTempB='KRDG?B';
fprintf(Lakeshore,ReadTempB);
Tbthermocouple=fscanf(Lakeshore);
pause(0.01)


T=[str2double(Ta),str2double(Tbthermocouple)];
fclose(Lakeshore);
delete(Lakeshore);
end