function PlotScale = PlotParameters(FitTot, Bxyz, ColorRescale, StdforRescalingTeslas,NumComp)

switch NumComp 
    case 4
        Bx_exp = Bxyz(:,:,1);
        By_exp = Bxyz(:,:,2);
        Bz_exp = Bxyz(:,:,3);

        Bn_exp = sqrt(Bx_exp(:,:).^2 + By_exp(:,:).^2 + Bz_exp(:,:).^2);

        if ColorRescale == 1
            [Bxmin,Bxmax] = ComputeSmartLimits(Bx_exp,StdforRescalingTeslas);
            [Bymin,Bymax] = ComputeSmartLimits(By_exp,StdforRescalingTeslas);
            [Bzmin,Bzmax] = ComputeSmartLimits(Bz_exp,StdforRescalingTeslas);
            [Bnmin,Bnmax] = ComputeSmartLimits(Bn_exp,StdforRescalingTeslas);Bnmin = max([0,Bnmin]);
        else
            Bxmin = min(min(Bx_exp,'omitnan'),'omitnan');
            Bxmax = max(max(Bx_exp,'omitnan'),'omitnan');
            Bymin = min(min(By_exp,'omitnan'),'omitnan');
            Bymax = max(max(By_exp,'omitnan'),'omitnan');
            Bzmin = min(min(Bz_exp,'omitnan'),'omitnan');
            Bzmax = max(max(Bz_exp,'omitnan'),'omitnan');  
            Bnmin = min(min(Bn_exp,'omitnan'),'omitnan');
            Bnmax = max(max(Bn_exp,'omitnan'),'omitnan'); 
        end   
%         Bxmin = 9.2;
%         Bxmax = 9.4;
%         Bymin = 3.2;
%         Bymax = 3.6;
%         Bzmin = 1;
%         Bzmax = 1.4;
%         Bnmin = 9.8;
%         Bnmax = 10.2;
        
        PlotScale = {Bxmin,Bxmax,Bymin,Bymax,Bzmin,Bzmax,Bnmin,Bnmax};
    case 2
        StdforRescalingTeslas = 2*StdforRescalingTeslas; % seems better
        
        Bx_exp = Bxyz(:,:,1);
        By_exp = Bxyz(:,:,2);

        Bn_exp = sqrt(Bx_exp(:,:).^2 + By_exp(:,:).^2);
        
        C1 = FitTot(:,:,1);
        C2 = FitTot(:,:,2);
        C3 = FitTot(:,:,3);
        C4 = FitTot(:,:,4);
        FD1 = FitTot(:,:,5);
        FD2 = FitTot(:,:,6);

        if ColorRescale == 1            
            [C1min,C1max] = ComputeSmartLimits(C1,StdforRescalingTeslas);C1min = max([0,C1min]);C1min = C1min*100;C1max = C1max*100;
            [C2min,C2max] = ComputeSmartLimits(C2,StdforRescalingTeslas);C2min = max([0,C2min]);C2min = C2min*100;C2max = C2max*100;
            [C3min,C3max] = ComputeSmartLimits(C3,StdforRescalingTeslas);C3min = max([0,C3min]);C3min = C3min*100;C3max = C3max*100;
            [C4min,C4max] = ComputeSmartLimits(C4,StdforRescalingTeslas);C4min = max([0,C4min]);C4min = C4min*100;C4max = C4max*100;
            [FD1min,FD1max] = ComputeSmartLimits(FD1,0.5*StdforRescalingTeslas); 
            [FD2min,FD2max] = ComputeSmartLimits(FD2,0.5*StdforRescalingTeslas); 
            [Bxmin,Bxmax] = ComputeSmartLimits(Bx_exp,0.5*StdforRescalingTeslas);
            [Bymin,Bymax] = ComputeSmartLimits(By_exp,0.5*StdforRescalingTeslas);
            [Bnmin,Bnmax] = ComputeSmartLimits(Bn_exp,0.5*StdforRescalingTeslas);Bnmin = max([0,Bnmin]);
        else
            Bxmin = min(min(Bx_exp,'omitnan'),'omitnan');
            Bxmax = max(max(Bx_exp,'omitnan'),'omitnan');
            Bymin = min(min(By_exp,'omitnan'),'omitnan');
            Bymax = max(max(By_exp,'omitnan'),'omitnan'); 
            Bnmin = min(min(Bn_exp,'omitnan'),'omitnan');
            Bnmax = max(max(Bn_exp,'omitnan'),'omitnan');
            C1min = min(min(C1,'omitnan'),'omitnan');
            C1max = max(max(C1,'omitnan'),'omitnan');
            C2min = min(min(C2,'omitnan'),'omitnan');
            C2max = max(max(C2,'omitnan'),'omitnan');
            C3min = min(min(C3,'omitnan'),'omitnan');
            C3max = max(max(C3,'omitnan'),'omitnan');
            C4min = min(min(C4,'omitnan'),'omitnan');
            C4max = max(max(C4,'omitnan'),'omitnan');
            FD1min = min(min(FD1,'omitnan'),'omitnan');
            FD1max = max(max(FD1,'omitnan'),'omitnan');
            FD2min = min(min(FD2,'omitnan'),'omitnan');
            FD2max = max(max(FD2,'omitnan'),'omitnan');
        end 
        
        PlotScale = {C1min,C1max,C2min,C2max,C3min,C3max,C4min,C4max,FD1min,FD1max,FD2min,FD2max,Bxmin,Bxmax,Bymin,Bymax,Bnmin,Bnmax,};
        
    case 1

        StdforRescalingTeslas = 2*StdforRescalingTeslas; % seems better

        C1 = FitTot(:,:,1);
        C2 = FitTot(:,:,2);
        FD = FitTot(:,:,3);
        FM = FitTot(:,:,4);
        FW1 = FitTot(:,:,5);
        FW2 = FitTot(:,:,6);
        B = abs(Bxyz);

        if ColorRescale == 1
            [C1min,C1max] = ComputeSmartLimits(C1,StdforRescalingTeslas);C1min = max([0,C1min]);C1min = C1min*100;C1max = C1max*100;
            [C2min,C2max] = ComputeSmartLimits(C2,StdforRescalingTeslas);C2min = max([0,C2min]);C2min = C2min*100;C2max = C2max*100;
            [FMmin,FMmax] = ComputeSmartLimits(FM,2*StdforRescalingTeslas);
            [FDmin,FDmax] = ComputeSmartLimits(FD,0.5*StdforRescalingTeslas);            
            [FW1min,FW1max] = ComputeSmartLimits(FW1,StdforRescalingTeslas);         
            [FW2min,FW2max] = ComputeSmartLimits(FW2,StdforRescalingTeslas);
            [Bmin,Bmax] = ComputeSmartLimits(B,0.5*StdforRescalingTeslas);Bmin = max([0,Bmin]);  
        else
            C1min = min(min(C1,'omitnan'),'omitnan');
            C1max = max(max(C1,'omitnan'),'omitnan');
            C2min = min(min(C2,'omitnan'),'omitnan');
            C2max = max(max(C2,'omitnan'),'omitnan');
            FMmin = min(min(FM,'omitnan'),'omitnan');
            FMmax = max(max(FM,'omitnan'),'omitnan');
            FDmin = min(min(FD,'omitnan'),'omitnan');
            FDmax = max(max(FD,'omitnan'),'omitnan');
            FW1min = min(min(FW1,'omitnan'),'omitnan');
            FW1max = max(max(FW1,'omitnan'),'omitnan');
            FW2min = min(min(FW2,'omitnan'),'omitnan');
            FW2max = max(max(FW2,'omitnan'),'omitnan');
            Bmin = min(min(B,'omitnan'),'omitnan');
            Bmax = max(max(B,'omitnan'),'omitnan');
        end

        % Bmin = 0;
        % Bmax = 0.5;
        % FDmin = 50;
        % FDmax = 62;
        % FW1min = 5;
        % FW1max = 25;
        % FW2min = 5;
        % FW2max = 75;

        PlotScale = {C1min,C1max,C2min,C2max,FMmin,FMmax,FDmin,FDmax,FW1min,FW1max,FW2min,FW2max,Bmin,Bmax};      

    case 0.5
        StdforRescalingTeslas = 2*StdforRescalingTeslas;

        C = FitTot(:,:,1);
        FM = FitTot(:,:,2);
        FW = FitTot(:,:,3);

        if ColorRescale == 1
            [Cmin,Cmax] = ComputeSmartLimits(C,StdforRescalingTeslas);Cmin = max([0,Cmin]);Cmin = Cmin*100;Cmax = Cmax*100;
            [FMmin,FMmax] = ComputeSmartLimits(FM,StdforRescalingTeslas);
            [FWmin,FWmax] = ComputeSmartLimits(FW,StdforRescalingTeslas);
        else
            Cmin = min(min(C,'omitnan'),'omitnan');
            Cmax = max(max(C,'omitnan'),'omitnan');
            FMmin = min(min(FM,'omitnan'),'omitnan');
            FMmax = max(max(FM,'omitnan'),'omitnan');
            FWmin = min(min(FW,'omitnan'),'omitnan');
            FWmax = max(max(FW,'omitnan'),'omitnan');
        end

        % FDmin = 50;
        % FDmax = 62;
        % FWmin = 5;
        % FWmax = 25;

        PlotScale = {Cmin,Cmax,FMmin,FMmax,FWmin,FWmax};   
end
end
    