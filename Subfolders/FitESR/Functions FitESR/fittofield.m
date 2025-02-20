function [BOut,StrBField] = fittofield(FitTot, NumCompFit, NumCompRecon)
%Return the vectorial magnetic field in the frame of the diamond.
%FitTot can be a matrix of the fit results, or just one fit result.
%Follows the protocol described in the supplementary of Lesik et al 
%(Magnetic measurements on micron-size samples under high pressure using designed NV centers)
% Mayeul Chipaux, May14th, 2019
% 2gmub/h = 55.928 MHz/mT 

gmub = 55.928; % it is actually 2gmub/h = 55.928 MHz/mT

size_FitTot = size(FitTot);
if size_FitTot(1) == 1
    FitTotTmp = FitTot;
    clear FitTot
    FitTot(1,1,1:size_FitTot(2)) = FitTotTmp;
end

if FitTot == 0
    BOut = 0;
    StrBField = 'Error';
else
switch NumCompFit
    case 0.5
        BOut = 0; %cannot determine magnetic field
    case 1
        BOut = sqrt(3)*FitTot(:,:,3)/gmub;
    case 2
        BTmp(:,:,:) = FitTot(:,:,5:6)/gmub;
        BOut = zeros([size(BTmp(:,:,1)), 3]); %We will have Bz= B(:,:,3) = 0
        BOut(:,:,1) = sqrt(3)/2*(-BTmp(:,:,1)+BTmp(:,:,2));%(-Ba+Bb);
        BOut(:,:,2) = sqrt(3)/2*(-BTmp(:,:,1)-BTmp(:,:,2));%(-Ba-Bb);        
    case 3
        disp('Not implemented yet')
    case 4
        switch NumCompRecon
            case 1
                BOut = sqrt(3)*FitTot(:,:,3)/gmub;
            case {3, 4}     % In both these cases, we consider that the four components
                % are present in FitTot. We will just take three out of
                % the four in case one is more noisy or less accurate
                % than the others
                
                BTmp(:,:,:) = FitTot(:,:,9:12)/gmub;
                if (mean(mean(BTmp(:,:,1)))-mean(mean(BTmp(:,:,2)))-mean(mean(BTmp(:,:,3)))+mean(mean(BTmp(:,:,4))))^2 > ...
                        (-mean(mean(BTmp(:,:,1)))-mean(mean(BTmp(:,:,2)))-mean(mean(BTmp(:,:,3)))+mean(mean(BTmp(:,:,4))))^2
                    BTmp(:,:,1) = - BTmp(:,:,1); % Ba = -Ba
                end
                BTmp(:,:,2) = - BTmp(:,:,2); % Bb = -Bb
                BTmp(:,:,3) = - BTmp(:,:,3); % Bc = -Bc
                if NumCompRecon == 3
                    % First, we select the component that has the smaller contrast in average
                    contrast = zeros(4,1);
                    for i = 0:3 %The contrasts in jx (FitTot) are in position 1:8
                        contrast(i+1) = mean((mean(FitTot(:,:,2*i+1)))) + mean(mean(FitTot(:,:,2*i+2)));
                    end
                    [~, im] = min(contrast);
                    
                    % Then we replace this measurement by the opposite of the sum of
                    % the three others (see eq. III.12 in Mayeul's Thesis), so we
                    % can use the same formula as if we had the four components
                    % available (see Eq. III.24 and III.25 in Mayeul's Thesis)
                    % for example, Baout = BaIn - BaIn - BbIn - BcIn - BdIn
                    % so BaOut = - BbIn - BcIn - BdIn (the im component is
                    % canceled)
                    BTmp(:,:,im) = BTmp(:,:,im) - BTmp(:,:,1)- BTmp(:,:,2)- BTmp(:,:,3)- BTmp(:,:,4);
                end
                
                BOut = zeros([size(BTmp(:,:,1)), 3]);
                BOut(:,:,1) = sqrt(3)/4*(-BTmp(:,:,1)+BTmp(:,:,2)-BTmp(:,:,3)+BTmp(:,:,4));%(-Ba+Bb-Bc+Bd);
                BOut(:,:,2) = sqrt(3)/4*(-BTmp(:,:,1)+BTmp(:,:,2)+BTmp(:,:,3)-BTmp(:,:,4));%(-Ba+Bb+Bc-Bd);
                BOut(:,:,3) = sqrt(3)/4*(-BTmp(:,:,1)-BTmp(:,:,2)+BTmp(:,:,3)+BTmp(:,:,4));%(-Ba-Bb+Bc+Bd);
        end
end

if ~isempty(BOut)
    if NumCompFit == 0.5
        B = BOut;
        StrBField = 'Only 1 peak fitted, cannot determine magnetic field';
    elseif NumCompFit == 1
        B = mean(mean(BOut(:,:)));
        StrBField = ['B = ' num2str(roundn(B,-2)) ' mT'];
    elseif NumCompFit == 2
        %     B1 = BOut(:,:,1); B2 = BOut(:,:,2); Btot = sqrt(B1^2+B2^2^3);
        B1 = mean(mean(BOut(:,:,1))); B2 = mean(mean(BOut(:,:,2))); B3 = mean(mean(BOut(:,:,3))); Btot = sqrt(B1^2+B2^2+B3^3);
        StrBField = ['B1 = ' num2str(roundn(B1,-2)) ' mT, B2 = ' num2str(roundn(B2,-2)) ' mT, Btot = ' num2str(roundn(Btot,-2)) ' mT'];
    elseif NumCompFit == 4
        %     B1 = BOut(:,:,1); B2 = BOut(:,:,2); B3 = BOut(:,:,3); Btot = sqrt(B1^2+B2^2+B3^3);
        B1 = mean(mean(BOut(:,:,1))); B2 = mean(mean(BOut(:,:,2))); B3 = mean(mean(BOut(:,:,3))); Btot = sqrt(B1^2+B2^2+B3^3);
        StrBField = ['B1 = ' num2str(roundn(B1,-2)) ' mT, B2 = ' num2str(roundn(B2,-2)) ' mT, B3 = ' num2str(roundn(B3,-2)) ' mT, Btot = ' num2str(roundn(Btot,-2)) ' mT'];
    end
else
    StrBField ='Error';
end

end
% disp(StrBField);

end


