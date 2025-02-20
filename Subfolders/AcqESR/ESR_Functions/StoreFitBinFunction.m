function StoreFitBinFunction(~,~)
global M Ftot

B = fileread([getPath('Param') 'jxBin.txt']);
fid = fopen([getPath('Param') 'PstartFit.txt'],'w');
fprintf(fid,B);
fclose(fid);
fid = fopen([getPath('Param') 'PstartFitBin.txt'],'w');
fprintf(fid,B);
fclose(fid);

panel = guidata(gcbo);

if panel.Fit.Value && panel.UsePstart.Value    
    h = EraseFit();
    h = CreateFit();
    guidata(gcbo,h);
end

end

