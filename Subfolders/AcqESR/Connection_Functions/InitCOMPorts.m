function InitCOMPorts(panel)
global SetupType

load([getPath('Param') 'AcqParameters.mat']);

switch SetupType

    case "CEA"
        try
            Lakeshore = serialport("COM" + AcqParameters.COM_Lakeshore, 57600,"DataBits",7,"Parity","odd");
            disp("Lakeshore connected successfully.");
            configureTerminator(Lakeshore,"CR/LF")
            flush(Lakeshore);
            panel.UserData.Lakeshore = Lakeshore;
        catch
            disp("Warning: Unable to connect to Lakeshore. Device not detected or wrong COM port.");
        end
        try
            Betsa = serialport("COM" + AcqParameters.COM_Betsa, 9600);
            disp("Betsa connected successfully.");
            flush(Betsa);
            panel.UserData.Betsa = Betsa;
            writeline(Betsa, "RLY61"); % turns reflected light on
            panel.light.Value = 1;
            panel.light.ForegroundColor = [0,0,1];
            writeline(Betsa, "RLY50"); % switches shutter toward light mode
            panel.shutterBetsa.Value = 1;
            panel.shutterBetsa.ForegroundColor = [0,0,1];
        catch
            disp("Warning: Unable to connect to Betsa. Device not detected or wrong COM port.");
        end

    case "ENS1"
        try
            Lakeshore = serialport("COM" + AcqParameters.COM_Lakeshore, 57600,"DataBits",7,"Parity","odd");
            disp("Lakeshore connected successfully.");
            configureTerminator(Lakeshore,"CR/LF")
            flush(Lakeshore);
            panel.UserData.Lakeshore = Lakeshore;
        catch
            disp("Warning: Unable to connect to Lakeshore. Device not detected or wrong COM port.");
        end

    otherwise

end

guidata(gcf,panel);

end