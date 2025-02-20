function vf= voigtfunc(frequence, peakloc, peakint, widthgauss, widthlor)
% vf= voigt(v,par0)
% input  --v: wavenumber
%        --par0: initial parameters. 4 by g matrix,first row is peak
%                position, second row is intensity,third row is Gaussian width, 
%                fourth row is Lorentzian width
%               
% output -- vf: voigt 


v0=peakloc;
s=peakint;
ag=widthgauss/2;
al=widthlor/2;

aD=(ones(length(frequence),1)*ag);

vv0=frequence*ones(1,length(v0))-ones(length(frequence),1)*v0;
x=vv0.*(sqrt(log(2)))./aD;
y=ones(length(frequence),1)*(al./ag)*(sqrt(log(2)));
z=x+1i*y;
w = fadf(z);       % uses The code written by Sanjar M. Abrarov and Brendan M. Quine, York
%                      % University, Canada, March 2015.
vf=real(w)*s';
end
