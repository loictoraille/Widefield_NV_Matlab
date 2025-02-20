function [EsrImgM, x_um, y_um, v_MHz, FitTot, TrackingFit, VarWidths, smoothSize] = openEsrImgFittot(isPlot, pname, fname)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% In case the pathname is not specified, we select a deflaut one here.
if nargin <2 % if no path name, take one by default
    pname = 'C:\Users\Mayeul Chipaux\Documents\Data\Géologie\EsrImgMATLAB\FitTot\';
end

if nargin < 3 %if not fname, select one with a selection box
    ext = '*.mat';
    [fname,pname] = uigetfile(ext,'Load file',pname);
end
[FitTot, TrackingFit, VarWidths, smoothSize] = OpenFitTot(pname, fname);
pname = pname(1:end-7);
[EsrImgM, x_um, y_um, v_MHz] = openEsrImg(pname, fname);


if isPlot
    iv = floor(length(v_MHz)/2);
    plotEstImgXY(EsrImgM, x_um, y_um, fname, iv)
    iy = floor(length(y_um)/2);
    plotEsrImgXV(EsrImgM, x_um, v_MHz, fname, iy)
end

