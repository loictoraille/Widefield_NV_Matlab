T=[];
t=[];

a=instrfind;
while ~isempty(a)
    b=a(1);
    fclose(b);
    delete(b);
    a=instrfind;
end

Lakeshore=serial('COM6','Baudrate',57600,'Databits',7,'Parity','odd','Terminator','CR/LF');
fopen(Lakeshore);

tic

while 1==1
% T=[T;ReadTemp()];
ReadTempA='KRDG?A';
fprintf(Lakeshore,ReadTempA);
Ta=fscanf(Lakeshore);
pause(0.01)
ReadTempB='KRDG?B';
fprintf(Lakeshore,ReadTempB);
Tbthermocouple=fscanf(Lakeshore);
pause(0.01)
Temp=[str2double(Ta),str2double(Tbthermocouple)];

T=[T;Temp];
mes_tim = toc/60;%min
t=[t;mes_tim];
figure(2)
hold off
plot(t,T(:,1))
hold on
plot(t,T(:,2))
xlabel('Time (minutes)');
ylabel('Temperature');
% legend('Temperature of far thermocouple A (K)','Temperature of close thermocouple B (K)','Position','southeast');
pause(1);
end

%% 

fclose(Lakeshore);
delete(Lakeshore);

% saveName = ['./Data/'  date '-Descente_température'];
% save([saveName '.mat']);
% saveas(figure(2),[saveName '.jpg'], 'jpeg');
