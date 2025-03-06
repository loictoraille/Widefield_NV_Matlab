function T=ReadTemp()

panel = guidata(gcf);

if isfield(panel,'UserData') && isfield(panel.UserData,'Lakeshore')
    Lakeshore = panel.UserData.Lakeshore;
    flush(Lakeshore);

    ReadTempA='KRDG?A';
    writeline(Lakeshore, ReadTempA);
    Ta = readline(Lakeshore); % dummy because first one sometimes doesn't work
    writeline(Lakeshore, ReadTempA);
    Ta = readline(Lakeshore);
    pause(0.01)

    % INTYPEB='INTYPE B,1,0,0,0,1'; % INTYPEB='INTYPE B,4,0,0,1,1';%
    % writeline(Lakeshore,INTYPEB);
    % pause(0.5);
    % INCRVB='INCRV B,2'; %INCRVB='INCRV B,13';%
    % writeline(Lakeshore,INCRVB);
    % pause(0.5);
    % ReadTempB='KRDG?B';
    % writeline(Lakeshore,ReadTempB);
    % Tbdiode=readline(Lakeshore);
    %
    % INTYPEB='INTYPE B,4,0,0,1,1';
    % writeline(Lakeshore,INTYPEB);
    % pause(0.5);
    % INCRVB='INCRV B,13';%
    % writeline(Lakeshore,INCRVB);
    % pause(2);

    ReadTempB='KRDG?B';
    writeline(Lakeshore,ReadTempB);
    Tbthermocouple=readline(Lakeshore);
    writeline(Lakeshore,ReadTempB);
    Tbthermocouple=readline(Lakeshore);% dummy because first one sometimes doesn't work
    pause(0.01)


    T=[str2double(Ta),str2double(Tbthermocouple)];

else
    T = [NaN,NaN];
end

end