clearvars; addpath('Function CurrentReconstruction');

%% FILE LOADING

% load('/Users/antoinehilberer/Documents/MATLAB/Stage M2/FitESR 19-04-19/Data traitées/2014-07-18-6-Fit-Smooth2.mat','B');
% B1 = B;
% load('/Users/antoinehilberer/Documents/MATLAB/Stage M2/FitESR 19-04-19/Data traitées/2014-07-18-R-Fit-Smooth2.mat','B');
% B2 = B;


% [fname,pname] = uigetfile('*.mat','Load file',DataPath);
% load([pname fname]);
% Bx1 = Bx_exp;By1 = By_exp;Bz1 = Bz_exp;
% %B1 = B;
% [fname,pname] = uigetfile('*.mat','Load file',DataPath);
% load([pname fname]);
% Bx2 = Bx_exp;By2 = By_exp;Bz2 = Bz_exp;

DataPath = '/Users/antoinehilberer/Documents/MATLAB/Stage M2/Data traitées/';
[fname,pname] = uigetfile('*.mat','Load file',DataPath);
load([pname fname]);
B1 = B;

DataPath = '/Users/antoinehilberer/Documents/MATLAB/Stage M2/Data traitées/';
[fname,pname] = uigetfile('*.mat','Load file',DataPath);
load([pname fname]);
B2 = B;
B = (B1-B2)/2;

[h,w,~] = size(B);


%% NUMERICAL PARAMS%
crop = 0;
zmes =10e-6;
pixconv = 0.5e-6;
mu = 4*pi*1e-7;
Fsmoothing = 0;

if crop == 1
    B = B(:,100:400,:);
    [h,w,~] = size(B);
end
%%
% Bz = Bx1 - Bx2;
% Bx = By1 - By2;
% By = Bz1 - Bz2;

%%
Bx = B(:,:,1);
By = B(:,:,3);
Bz = B(:,:,2);
%%
Current_plotB(Bx,By,Bz,2,1,'Measured B field');

%% FIELD ROTATION


rot_angle = 45 ; 
rot_angle = rot_angle*pi/180;
rotation_matrix = [cos(rot_angle) -sin(rot_angle) 0;sin(rot_angle) cos(rot_angle) 0;0 0 1];

RotBx = zeros(h,w);
RotBy = zeros(h,w);
RotBz = zeros(h,w);

for xpix = 1:h
    for ypix = 1:w
        vector_B = [Bx(xpix,ypix) By(xpix,ypix) Bz(xpix,ypix)];
        rotated_field = rotation_matrix*vector_B';
        RotBx(xpix,ypix) = rotated_field(1);
        RotBy(xpix,ypix) = rotated_field(2);
        RotBz(xpix,ypix) = rotated_field(3);
    end
end

Current_plotB(RotBx,RotBy,RotBz,3,1,'Rotated B field');
%% RESOLUTION
Bx = RotBx;
By = RotBy;
Bz = RotBz;

Bx = Bx.*1e-3;
By = By.*1e-3;
Bz = Bz.*1e-3;

bx = fftshift(fft2(Bx));
by = fftshift(fft2(By));
bz = fftshift(fft2(Bz));

% figure(1)
% clims = [0 10];
% imagesc(abs(bx))
% axis('image')
% colorbar
%%
if Fsmoothing == 1
    bx = FourierFilter(bx,30,150);
    by = FourierFilter(by,30,150);
    bz = FourierFilter(bz,30,150);
end
%%
% Bfx = real(ifft2(ifftshift(bx)));
% Bfy = real(ifft2(ifftshift(by)));
% Bfz = real(ifft2(ifftshift(bz)));
% Current_plotB(Bfx,Bfy,Bfz,4,0,'Smoothed B field');


%%
jx = zeros(h,w);
jy = zeros(h,w);
facts = zeros(h,w);
ks = zeros(h,w);

s = 0;
for xpix = 1:h
    kx = ((xpix-floor(h/2))-1);
    for ypix = 1:w
        ky = ((ypix-floor(w/2))-1);
        k = sqrt(kx^2 +ky^2);
        ks(xpix,ypix) = k;
        if k~=0
            fact = (mu/2)*exp(-zmes*k);
            facts(xpix,ypix) = fact;
            M = [0 fact;-fact 0;1i*fact*ky/k -1i*fact*kx/k;kx ky];
            bvect = [bx(xpix,ypix) by(xpix,ypix) bz(xpix,ypix) 0];
            result = M\bvect';
            jx(xpix,ypix) = result(1) ; jy(xpix,ypix) = result(2);
            if isnan(result(1)) || isnan(result(2))
                disp(xpix)
                disp(ypix)
            end
        else
            s=1;
            x_zero = xpix;
            y_zero = ypix;
        end
    end
end
disp('Done solving');
%%
%imagesc(abs(jx))
%%
Jx = real(ifft2(ifftshift(jx)));
Jy = real(ifft2(ifftshift(jy)));
Jx = Jx(end:-1:1,end:-1:1);
Jy = Jy(end:-1:1,end:-1:1);
J = sqrt(Jx.^2 + Jy.^2);

%%
Current_plotJ(Jx,Jy,J,5,1,'Reconstructed current')
%%
Rbx = zeros(h,w);
Rby = zeros(h,w);
Rbx = zeros(h,w);

for xpix = 1:h
    kx = (xpix-floor(h/2))-1;
    for ypix = 1:w
        ky = (ypix-floor(w/2))-1;
        k = sqrt(kx^2 +ky^2);
        if k~=0
            fact = (mu/2)*exp(-zmes*k);
            facts(xpix,ypix) = fact;
            M = [0 fact;-fact 0;1i*fact*ky/k -1i*fact*kx/k;kx ky];
            bvect = [bx(xpix,ypix) by(xpix,ypix) bz(xpix,ypix) 0];
            jvect = [jx(xpix,ypix) jy(xpix,ypix)];
            result = M*jvect';
            Rbx(xpix,ypix) = result(1); Rby(xpix,ypix) = result(2); Rbz(xpix,ypix) = result(3);
        end
    end
end
RBx = real(ifft2(ifftshift(Rbx))).*1e3;
RBy = real(ifft2(ifftshift(Rby))).*1e3;
RBz = real(ifft2(ifftshift(Rbz))).*1e3;
%%
Current_plotB(RBx,RBy,RBz,4,1,'B field from recons. current');