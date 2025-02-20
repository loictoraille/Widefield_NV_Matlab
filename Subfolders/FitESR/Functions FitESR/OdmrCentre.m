function middleFreq = OdmrCentre(v_MHz,Spectre)
% correlation method with a rectangle kernel

Size_Mask = 10;
Dist_Between= 1;
        
sizeSpectre = length(Spectre);
SpectreReshaped = reshape(Spectre,[1,sizeSpectre]);

k = ones([1 1+2*round(sizeSpectre/Size_Mask)]);
centre = round(length(k)/2);
k(centre-Dist_Between:centre+Dist_Between) =  0;

Xcorr = conv(max(SpectreReshaped)-SpectreReshaped,k,"same");

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
