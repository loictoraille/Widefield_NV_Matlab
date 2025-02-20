function spOut = extractEsrSp(ESRMatrix, ix, iy, binningOddNumber)
% extractEsrSp extracts the sum of the spectra that are inside a square
% with a odd number of pixel side (1, 3*3, 5*5, 7*7...) centered around (ix, iy)
% If the side were even, the square coudn't be really centered around (ix, iy)
% for binning = 1 or 2, we take only the spectrum in (ix, iy)
% for binning = 3 or 4, we take the spectra from the square of 3*3 (9 pixels)
% for binning = 5 or 6, we take a square of 5*5 (25 pixels) ...
% Mayeul Chipaux, April 14th, 2019


if nargin < 4 
    binningOddNumber = 1; 
end

[h,w, ~] = size(ESRMatrix);
count = 1;
spOut = squeeze(ESRMatrix(iy,ix,:));
if binningOddNumber > 2
    n = floor((binningOddNumber-1)/2); % for binning = 2*n + 1 or 2*n + 2, we take n
    for i = -n:1:n 
    for j = -n:1:n
        if (i~=0 || j~= 0)  && ix + i > 1 && ix + i < w ...
                            && iy + j > 1 && iy + j < h 
            % we make sure not to take the spectra in (ix, iy) again
            % and not to take any spectra out from the the Cimg
            spOut = spOut + squeeze(ESRMatrix(iy + j,ix + i,:)); 
            count = count + 1;
        end
    end
    end
end
    
spOut = spOut ./ count;
    
    
    
end