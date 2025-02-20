function [B_out, Perm_out] = DefineCorrectPermutation(B_in,Perm_in)
% B can be any combination, with any sign, of B1, B2 and B3
% if called with a perm_in parameter, this parameter will be used
% if not, a prompt asks the user to choose the correct permutation

B_out = B_in;

if B_in == 0
elseif length(size(B_in)) ~= 3
    B1 = B_in(1);
    B2 = B_in(2);
    B3 = B_in(3);
else
    B1 = roundn(mean(mean(B_in(:,:,1))),-2);
    B2 = roundn(mean(mean(B_in(:,:,2))),-2);
    B3 = roundn(mean(mean(B_in(:,:,3))),-2);
end

if nargin == 2
    Perm_in = str2num(Perm_in);
    Perm_out = Perm_in;
else
    Perm_out = zeros(3);
    prompt = {'Bx = ','By = ','Bz = '};
    title = ['B1 = ' num2str(B1) ' mT, B2 = ' num2str(B2) ' mT, B3 = ' num2str(B3) 'mT'];
    definput = {'B2','-B1','B3'};
    opts.Resize = 'on';
    answer = inputdlg(prompt,title,[1 75],definput,opts);
    
    for i=1:3
        Perm_out(i) = str2num(erase(string(answer(i,1)),'B'));
    end
    
    disp(['Perm = [' num2str(Perm_out(1)) ',' num2str(Perm_out(2)) ',' num2str(Perm_out(3)) ']']);
end

for i=1:3
    if B_in == 0
    elseif length(size(B_in)) ~= 3
        B_out(i) = sign(Perm_out(i))*B_in(abs(Perm_out(i)));
    else
        B_out(:,:,i) = sign(Perm_out(i))*B_in(:,:,abs(Perm_out(i)));
    end
end

end