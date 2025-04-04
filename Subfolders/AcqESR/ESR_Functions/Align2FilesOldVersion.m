function  [crop1_out,crop2_out] = Align2Files(Pic1,Pic2,PLOT)
%
% takes 2 pictures and perform a correlation to realign both pictures
% returns [crop1_out,crop2_out]
% crop_out = [y_start,y_end,x_start,x_end] cropping values to be applied for each picture
% > Pic1crop = Pic1(crop1_out(1):crop1_out(2),crop1_out(3):crop1_out(4)); 
% > Pic2crop = Pic2(crop2_out(1):crop2_out(2),crop2_out(3):crop2_out(4));
% 
% syntax for FitESR Cropping_Coord:
% > Cropping_Coord = [1,crop(3),crop(1),crop(4),crop(2)] 

%% Main Function

% normxcorr2 must necessarily take arg1 smaller than arg2
% exchange_pics = 0;
% if numel(Pic1) > numel(Pic2)
%     PicInt = Pic2;
%     Pic2 = Pic1;
%     Pic1 = PicInt;
%     clear PicInt
%     exchange_pics = 1;
% end    

[h1,w1] = size(Pic1);
[h2,w2] = size(Pic2);

% C = normxcorr2(Pic1,Pic2); Has problems for image with sizes close to each other

requiredNumberOfOverlapPixels = numel(Pic1)/2;
%if looking to align two slightly mismatched images, the overlap can be set
%to half of numel ; if looking to find a small template inside a bigger
%picture, the overlab can be set smaller or even 0
C = normxcorr2_general(Pic1,Pic2,requiredNumberOfOverlapPixels);

[ypeak, xpeak] = find(C==max(C(:)));

% yoffSet1 = ypeak-h2;
% xoffSet1 = xpeak-w2;
% yoffSet2 = ypeak-h1;
% xoffSet2 = xpeak-w1;
% 
% yoffSet1 = ypeak-max(h1,h2);
% xoffSet1 = xpeak-max(w1,w2);
% yoffSet2 = ypeak-min(h1,h2);
% xoffSet2 = xpeak-min(w1,w2);
% 
% yoffSet1 = ypeak-h1;
% xoffSet1 = xpeak-w1;
% yoffSet2 = ypeak-h2;
% xoffSet2 = xpeak-w2;

if ypeak-h1 > 0
    yoffSet1 = ypeak-h2;
    yoffSet2 = ypeak-h1;
else
    yoffSet1 = ypeak-h1;
    yoffSet2 = ypeak-h2;
end
 
if xpeak-w1 > 0
    xoffSet1 = xpeak-w2;
    xoffSet2 = xpeak-w1;
else    
    xoffSet1 = xpeak-w1;
    xoffSet2 = xpeak-w2;
end

crop1 = [EasyResult(yoffSet1,1,1),EasyResult(yoffSet1,h1,2),EasyResult(xoffSet1,1,1),EasyResult(xoffSet1,w1,2)];
crop2 = [EasyResult(yoffSet2,1,2),EasyResult(yoffSet2,h2,1),EasyResult(xoffSet2,1,2),EasyResult(xoffSet2,w2,1)];

% crop1 = [EasyResult(yoffSet2,1,1),EasyResult(yoffSet2,h1,2),EasyResult(xoffSet2,1,1),EasyResult(xoffSet2,w1,2)];
% crop2 = [EasyResult(yoffSet2,1,2),EasyResult(yoffSet2,h1,1),EasyResult(xoffSet2,1,2),EasyResult(xoffSet2,w1,1)];

% crop1 = [EasyResult(yoffSet2,1,1),EasyResult(yoffSet2,h1,2),EasyResult(xoffSet2,1,1),EasyResult(xoffSet2,w1,2)];
% crop2 = [EasyResult(yoffSet1,1,2),EasyResult(yoffSet1,h2,1),EasyResult(xoffSet1,1,2),EasyResult(xoffSet1,w2,1)];


% if exchange_pics ~= 1 
%     crop1_out = crop1;
%     crop2_out = crop2;
% else
%     crop1_out = crop2;
%     crop2_out = crop1;
% end

    crop1_out = crop1;
    crop2_out = crop2;

Pic1crop = Pic1(crop1(1):crop1(2),crop1(3):crop1(4));
Pic2crop = Pic2(crop2(1):crop2(2),crop2(3):crop2(4));

if PLOT == 1
    
%     if exchange_pics ~= 1 
%         pic1str = "Pic1";
%         pic2str = "Pic2";
%     else
%         pic1str = "Pic2";
%         pic2str = "Pic1";
%     end
           
    Position = FigSizePosition(0.3);
    PositionL = Position; PositionL(1) = PositionL(1) - 0.6*PositionL(3);
    PositionR = Position; PositionR(1) = PositionR(1) + 0.6*PositionR(3);
    
    figure('Position',PositionL)
    imagesc(Pic1)
    title(pic1str + " before crop")
    axis('image')
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel('x (pixels)');
    ylabel('y (pixels)'); 
    
    figure('Position',PositionL)
    imagesc(Pic2)
    title(pic2str + " before crop")
    axis('image')    
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel('x (pixels)');
    ylabel('y (pixels)'); 
    
    figure('Position',PositionR)
    imagesc(Pic1crop)
    title(pic1str + " after crop")
    axis('image')
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel('x (pixels)');
    ylabel('y (pixels)'); 
    
    figure('Position',PositionR)
    imagesc(Pic2crop)
    title(pic2str + " after crop")
    axis('image')    
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel('x (pixels)');
    ylabel('y (pixels)'); 
    
end


%% Local Functions

% there is probably a better way to do it, but it works
function val_out = EasyResult(offset,val,num)
if val == 1
    ind = 1;
else
    ind = -1;
end
ret = val+ind*abs(offset);
if offset < 0
    if num == 1 
        val_out = ret;
    else
        val_out = val;
    end
else
    if num == 1 
        val_out = val;
    else
        val_out = ret; 
    end
end
end

end
