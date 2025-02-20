function [FNames, pName] = FitFolder(VarWidths, pName)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2 
    pName = 'C:\Users\Mayeul Chipaux\Documents\Data'; 
end

AcquisitionType = 'M software';%'M software';'C software'
ext = '*.cimg';
if AcquisitionType == 'M software'
    ext = '*.mat';
end
[FNames,pName] = uigetfile(ext,['Select the ' AcquisitionType ], 'MultiSelect','on',pName);

VarWidths = 0;
TrackingFit = 0;
smoothSize = 3;

for fName = FNames
    fNamest = strjoin(fName);
    [Cimg, x_um, y_um, v_MHz] = openEsrImg(pName, fNamest);
    FitTot = FitCimg(Cimg, v_MHz, VarWidths, 0, 3);
    Bxyz = fittofield(FitTot);
    plotField(Bxyz, x_um, y_um, 3, fNamest)
    file = [pName, 'FitTot\', fNamest];

    save(file, 'FitTot','VarWidths','TrackingFit','smoothSize')
end
end
