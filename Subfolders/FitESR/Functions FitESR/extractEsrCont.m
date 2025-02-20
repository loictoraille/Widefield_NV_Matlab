function spOut = extractEsrCont(ESRMatrix, ix, iy, binReal)
% extractEsrSp extracts the spectrum from a square of side binningRealNumber that
% can be any real. When it is not an even number, it takes a linear
% combination between the odd number just below and the one juste above
% Mayeul Chipaux, April 14th, 2019

if binReal == 0
    spOut = extractEsrSp(ESRMatrix, ix, iy, 1);
elseif mod(binReal, 2) == 1
    spOut = extractEsrSp(ESRMatrix, ix, iy, binReal);
else
    binOdd = 2*floor((binReal - 1)/2)+1; % we select the odd number below
    
    coef = ( binReal^2 - binOdd^2 )/( (binOdd+2)^2 - binOdd^2 );
    % We take a linear combination in the number of pixel to be taken that 
    % is equal to the square of the binning. For example, for binning = 4
    % we would have liked to take make the sum of 4^2 = 16 pixel, so we
    % take a linear combination as coef = (16 - 9) / (25 - 9)
    % ou sqrt(9) = 3, the odd bining below, and sqrt(25) = 5, the odd number above. 
    
    spOut = (1-coef) * extractEsrSp(ESRMatrix, ix, iy, binOdd)...
             + coef  * extractEsrSp(ESRMatrix, ix, iy, binOdd+2);

end

