function [EsrImgM, v_MHz] = LoadEsrM(pname,fname)
    file=[pname fname];
    load(file,'M','Ftot');
    EsrImgM = M;

    v_MHz = 10^3*Ftot;
    
end

