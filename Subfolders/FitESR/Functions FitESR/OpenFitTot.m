function [FitTot, TrackingFit, VarWidths, smoothSize] = OpenFitTot(pname, fname)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% If no entries, select one anyway.
    if nargin == 0 % if no path name, take one by default
        pname = 'C:\Users\Mayeul Chipaux\Documents\Data\Géologie\EsrImgMATLAB\';
    end
    if nargin ~= 2 %if not fname, select one with a selection box
        ext = '*.mat';
        [fname,pname] = uigetfile(ext,'Load file',pname);
    end
    
    file=[pname fname];
    S = load(file,'FitTot', 'TrackingFit', 'VarWidths', 'smoothSize');
    FitTot = S.FitTot;
    TrackingFit = S.TrackingFit;
    VarWidths = S.VarWidths;
    smoothSize =  S.smoothSize;
end

