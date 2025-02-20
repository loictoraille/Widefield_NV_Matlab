function [v_MHzOut, spOut] = extSubSp(v_MHzIn, spIn, vMed_MHz, vSpan_MHz)
%diffSp returns a subspectrum of spIn, from spIn(vMed-vSpan/2) to spIn(vMed+vSpan/2)


vStep_MHz = v_MHzIn(2)- v_MHzIn(1);
vMed_Ind = 1 + round((vMed_MHz - v_MHzIn(1))/vStep_MHz);
vSpan_Ind = round(vSpan_MHz/(2*vStep_MHz));
% vec_Ind = (vMed_Ind-vSpan_Ind):(vMed_Ind+vSpan_Ind);
vec_Ind = max(vMed_Ind-vSpan_Ind,1):min(vMed_Ind+vSpan_Ind,length(v_MHzIn));
v_MHzOut = v_MHzIn(vec_Ind);
spOut = spIn(vec_Ind);
end

