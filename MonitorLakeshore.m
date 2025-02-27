T=[];
t=[];

a=instrfind;
while ~isempty(a)
    b=a(1);
    fclose(b);
    delete(b);
    a=instrfind;
end

% Define serial port connection
Lakeshore = serialport("COM3", 57600,"DataBits",7,"Parity","odd");
configureTerminator(Lakeshore,"CR/LF")

% Flush any existing data
flush(Lakeshore);

tic

while 1==1
% T=[T;ReadTemp()];
ReadTempA='KRDG?A';
writeline(Lakeshore, ReadTempA);
Ta = readline(Lakeshore);
pause(0.01)
ReadTempB='KRDG?B';
writeline(Lakeshore, ReadTempB);
Tbthermocouple = readline(Lakeshore);
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

clear Lakeshore

% saveName = ['./Data/'  date '-Descente_température'];
% save([saveName '.mat']);
% saveas(figure(2),[saveName '.jpg'], 'jpeg');
