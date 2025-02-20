function figPosition = FigSizePosition(Num_Success,varargin)

if nargin == 2, ratio = varargin{1}; else, ratio = 0;end

screensize = get(groot,'Screensize');

wS = screensize(3);
hS = screensize(4);

if length(Num_Success) == 1
    scale = Num_Success;
elseif length(Num_Success) <= 18
    scale = 0.5;
elseif length(Num_Success) <= 35
    scale = 0.85;
else
    scale = 0.97;
end

if ratio ~= 0
    
    h = floor(hS*scale);
    w = floor(h*ratio);
    
else
    
    w = floor(wS*scale);
    h = floor(w*9/16);
    
end

remW = floor((wS-w)/2);
remH = floor((hS-h)/2);

figPosition = [remW,remH,w,h];


end