function [Base, Corrected_Spectrum]=baseline(Spectrum,WidthMinToKeep)
% retire des pics de plus en plus large en smoothant sur une fenêtre de
% plus en plus large, jusqu'à atteindre un point où une étape de retrait
% n'est plus avantageuse par rapport à la précédente

    % The AutoBase proceeds with a lot of sgolayfilt, which takes a long
    % time, for generally little to no value in the result if the spectrum
    % is flat. Only use if really needed.


%Input
%-------
%Spectrum: vector of size (N*1)

%Output
%-------
%Base: Identified Baseline vector of size (N*1)
%Corrected_Spectrum: Corrected Spectrum vector of size (N*1)

l=length(Spectrum); 

lp=ceil(0.5*l);

initial_Spectrum=[ones(lp,1)*Spectrum(1) ; Spectrum ; ones(lp,1)*Spectrum(l)];

l2=length(initial_Spectrum);

S=initial_Spectrum;

n=1;

flag1=0;

while flag1==0
    
n=n+2;
    
i=(n-1)/2;
    
[Baseline, stripping]=peak_stripping(S,n);

A(i)=trapz(S-Baseline);

Stripped_Spectrum{i}=Baseline;

S=Baseline;

if i>WidthMinToKeep
    if A(i-1)<A(i-2) && A(i-1)<A(i)
        i_min=i-1;
        flag1=1;
    end 
end

if n>l2-2
    flag1=1;
%     disp('Had to stop before converging');
    i_min=i;
end

end


Base=Stripped_Spectrum{i_min}; 
Base = medfilt1(Base,3);

Corrected_Spectrum=initial_Spectrum-Base; Corrected_Spectrum=Corrected_Spectrum(lp+1:lp+l);

Base=Base(lp+1:lp+l);

end