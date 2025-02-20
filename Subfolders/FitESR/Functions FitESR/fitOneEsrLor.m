function jx = fitOneEsrLor(spectre, pStart, pLb, pUb, F)
% lsqnonlin is one way to do it, there are several more ways

Fres = @(p) F(p) - spectre;
options = optimoptions('lsqnonlin','Display', 'off');
[jx,jresnorm,jres,jeflag,joutput1] = lsqnonlin(Fres,pStart,pLb, pUb,options); % Invoke optimizer

% CheckBounds(jx,lb,ub); % the lower bound on the base is always limiting for now

end

