 
%% 

[a,b,~] = size(M);
SPX = Ftot;

WidthMinToKeep = 50;
minDistBetweenPeaks = 1;


WidthMinToKeep = convertToPixels(SPX,WidthMinToKeep);
minDistBetweenPeaks = convertToPixels(SPX,minDistBetweenPeaks);

for i = 1:a
        if rem(i,10) == 0
            disp([num2str(i) '/' num2str(a)])
        end
    for j = 1:b
        SPY = squeeze(M(i,j,:));
        InvSPY = -SPY + max(SPY); % to have positive peaks
        [Base, Corrected_Intensity]=baseline(InvSPY,WidthMinToKeep);
        M_area(i,j) = sum(Corrected_Intensity);
    end
end

%% 

figure;
imagesc(M_area)
axis('image')
colorbar

%%

for i = 1:a
        if rem(i,10) == 0
            disp([num2str(i) '/' num2str(a)])
        end    
    for j=1:b
        SPY = squeeze(M(i,j,:));
        Renorm_val(i,j) = mean([mean(SPY(1:5)) mean(SPY(end-5:end))]);
        M_area_corr(i,j) = M_area(i,j)/Renorm_val(i,j);
    end
end

%% 

figure;
imagesc(M_area_corr)
axis('image')
colorbar
caxis([1 5]);


