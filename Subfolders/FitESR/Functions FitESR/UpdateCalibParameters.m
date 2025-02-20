
function [Calib_Dist,size_pix] = UpdateCalibParameters(AcqParameters,Calib_Dist,size_pix)

if isfield(AcqParameters,'CalibUnit_str')

    if strcmp(AcqParameters.CalibUnit_str,'pixel')
        Calib_Dist = 0;
    else
        Calib_Dist = 1;
    end

    size_pix = AcqParameters.PixelCalib_nm/1000; %conversion in µm

end

end