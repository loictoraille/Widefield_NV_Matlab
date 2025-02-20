function [spectre_dt] = Detrending(v_MHz, spectre, Detrending)
%removing a general trend in the ESR, the number is the degree of the polynome used
%only useful when the spectrum baseline is not horizontal
%try to use as low a degree as possible, I've gone up to 10 in some cases
%there could be improvement here

if Detrending == 0
    [spectre_dt] = spectre;    
else
    [p,s,mu] = polyfit(v_MHz,spectre,Detrending);
    f_y = polyval(p,v_MHz,[],mu);
%     spectre_dt = spectre - f_y + 0.998;
    spectre_dt = spectre - f_y + spectre(end);
    [spectre_dt] = spectre_dt;
end

end