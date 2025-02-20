function [dV_MHz,dSpectre] = diffSp(v_MHz, spectre, dv_MHz)
%diffSp returns the difference spectre(v + dv) -  spectre(v - dv)
%   it forms a kind of error function.

vStep = v_MHz(2)-v_MHz(1);
diN2 = floor(dv_MHz / (2*vStep));

dSpectre = spectre(1+diN2:end) - spectre(1:end-diN2);
dV_MHz = (v_MHz(1+diN2:end) + v_MHz(1:end-diN2))/2;
end

