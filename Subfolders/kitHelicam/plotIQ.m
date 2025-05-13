function plotIQ(I,Q)
    % plot IQ


    % plot time series of selected pixels

    xs = [100, 454];
    ys = [100, 412];
    cs = ['r','b'];
    
    NFrames = size(I,1);

    clf(subplot(2,2,1));
    clf(subplot(2,2,2));
    
    for i = 1:length(xs)
    
        subplot(2,2,i);
        plot(1:NFrames,I(:,xs(i),ys(i)),Color=cs(i),LineStyle="-")
        hold on
        plot(1:NFrames,Q(:,xs(i),ys(i)),Color=cs(i),LineStyle=":")
        hold on
        
        legend('I','Q')
        xlabel('frame number')
        ylabel('I/Q')
        title(['point ' num2str(i) ' (x=' num2str(xs(i)) ',y=' num2str(ys(i)) ')'])
        
    
    end
    

    % plot root mean square (rms) amplitude across field of view

    rms = squeeze(sqrt(mean(I.^2 + Q.^2)));
    
    subplot(2,2,[3,4])
    
    imagesc(rms)
    colorbar
    hold on
    
    for i = 1:length(xs)
    
        plot(xs(i),ys(i),Color=cs(i),Marker='+',MarkerSize=15,LineWidth=2);
        hold on
    
    end
    
    xlabel('x in pxl')
    ylabel('y in pxl')
    title('rms amplitude')
    
    hold off

end

