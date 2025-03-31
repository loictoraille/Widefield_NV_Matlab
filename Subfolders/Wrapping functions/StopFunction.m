function StopFunction(hobject,~)

if hobject.Value == 0
    hobject.ForegroundColor = [1,0,0];
else
    hobject.ForegroundColor = [0,0,1];
    disp('Stopping...');
end

end