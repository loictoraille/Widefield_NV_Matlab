function pStart = lastUpdatePstart(spectre, pStart)
%lastUpdatePstart % redefines a reasonable starting baseline y0 using the spectrum

pStart(end) = GetRenormValue(spectre);
end

