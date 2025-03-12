
function FrameRate_out = CheckFrameRate(FrameRate_in);
global ObjCamera CameraType

FrameRate_out = FrameRate_in;

FrameRateRange = GetFrameRateRange();

if FrameRate_in < FrameRateRange.Minimum 
    FrameRate_out = FrameRateRange.Minimum ;
end

if FrameRate_in > FrameRateRange.Maximum 
    FrameRate_out = FrameRateRange.Maximum ;
end


end
