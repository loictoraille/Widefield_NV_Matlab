function StoreFitPixFunction(~,~)
global M Ftot

A = fileread([getPath('Param') 'jx.txt']);
fid = fopen([getPath('Param') 'PstartFit.txt'],'w');
fprintf(fid,A);
fclose(fid);
fid = fopen([getPath('Param') 'PstartFitBin.txt'],'w');
fprintf(fid,A);
fclose(fid);

panel = guidata(gcbo);

if panel.Fit.Value && panel.UsePstart.Value    
    h = EraseFit();
    h = CreateFit();
    guidata(gcbo,h);
end

end

