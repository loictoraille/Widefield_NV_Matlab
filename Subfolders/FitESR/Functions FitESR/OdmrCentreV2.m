function middleFreq = OdmrCentreV2(v_MHz,Spectre)
% correlation method with a lorentzian kernel

spreading = 0.4; % a free parameter to adjuste (normally already optimum)
freqGap = 9.5/2 ;% constante in MHz (roughly half the distance between two peaks in lab condition)
signalWidth = 4; % increasing this number will decrease 

nbpoint = round(length(v_MHz)/signalWidth); % to change, it is an other parametre


if ~mod(nbpoint,2) 
    nbpoint = nbpoint+1;
end % odd number avoid a intrinsec shift
SpectreReshaped = reshape(Spectre,[1 length(Spectre)]);



X = v_MHz(1:nbpoint) - v_MHz(1);
mid = (X(1)+X(end))/2; %in MHz, half frequency gap between the two peak

kernel = 1./(1 + ((abs(X-mid)-freqGap)*spreading).^2); % creation of the kernel

Xcorr = conv(max(SpectreReshaped)-SpectreReshaped,kernel,"same");

% find_peak finds the precise X value of the maximum Y value using parabolic interpolation
% Inputs:
% - v_MHz: vector of X values
% - Xcorr: vector of Y values (noisy signal)
% Outputs:
% - middleFreq: the X value corresponding to the peak

% Find the maximum value and its index
[~, idx] = max(Xcorr);



% Parabolic interpolation using the points around the maximum
x1 = v_MHz(idx - 1);
x2 = v_MHz(idx);
x3 = v_MHz(idx + 1);
y1 = Xcorr(idx - 1);
y2 = Xcorr(idx);
y3 = Xcorr(idx + 1);

% Coefficients of the parabola y = ax^2 + bx + c
denom = (x1 - x2) * (x1 - x3) * (x2 - x3);
A = (x3 * (y2 - y1) + x2 * (y1 - y3) + x1 * (y3 - y2)) / denom;
B = (x3^2 * (y1 - y2) + x2^2 * (y3 - y1) + x1^2 * (y2 - y3)) / denom;

% Vertex of the parabola (x_peak, y_peak)
middleFreq = -B / (2 * A);

end
