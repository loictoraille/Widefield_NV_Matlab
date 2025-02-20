function Distance = GetDistCenter(Start_Corr_Cen,Lum_Start,Image,requiredNumberOfOverlapPixels)

Image_Corr_Cen = GetGaussianCenter(normxcorr2_general(Lum_Start,Image,requiredNumberOfOverlapPixels));

Distance = sqrt((Image_Corr_Cen(1)-Start_Corr_Cen(1))^2+(Image_Corr_Cen(2)-Start_Corr_Cen(2))^2);


end