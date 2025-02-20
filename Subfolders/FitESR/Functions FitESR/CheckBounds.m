
function CheckBounds(jx,lb,ub)

Z = length(jx);

indBound = 0;
for i=1:Z
    if (~isempty(lb) && abs((jx(i)-lb(i))) <= 1e-5) || (~isempty(ub) && abs((jx(i)-ub(i))) <= 1e-5)
        indBound = 1;
    end
end

if indBound == 1
    disp('fit was stopped by the defined boundaries')
end

end