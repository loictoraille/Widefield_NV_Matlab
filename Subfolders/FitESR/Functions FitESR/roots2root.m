function rOut = roots2root(RIn, V_MHz)
%From the results of a order 3 polynomial fit (3 roots), we select the good
%one
% Mayeul Chipaux, April 15th, 2019

if isreal(RIn) 
    % If the three roots are real, we should take the one in the middle.
    % exept if it isn't in the range of V_MHz. Then we take the closest to
    % the middle of the range.
    RIn = sort(RIn);
    if ~isempty(RIn)
    rOut = RIn(2);
    else
        rOut = NaN;
    end
    if (rOut < V_MHz(1) || rOut > V_MHz(end)) && ~isnan(rOut)
        [~, im] = min((RIn(:)-mean(V_MHz)).^2);
        rOut = RIn(im);
    end
else % in this case, there must be one roots that is real (Polynomial of 
     % order 3 must have to passe through 0). We take that one.
    for i=1:3
        if isreal(RIn(i))
            rOut = RIn(i);
            break;
        end
    end
end




end

