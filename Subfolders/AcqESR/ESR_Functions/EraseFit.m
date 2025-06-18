function h = EraseFit()

h=guidata(gcbo);

if isfield(h, 'l23') && isvalid(h.l23)
    delete(h.l23);
    h = rmfield(h, 'l23');  % Optionnel : nettoyer la structure
end

if isfield(h, 'l24') && isvalid(h.l24)
    delete(h.l24);
    h = rmfield(h, 'l24');
end

if isfield(h, 'l33') && isvalid(h.l33)
    delete(h.l33);
    h = rmfield(h, 'l33');
end

if isfield(h, 'l34') && isvalid(h.l34)
    delete(h.l34);
    h = rmfield(h, 'l34');
end

% ceintures bretelles

l23_tag = findobj('tag','l23');
delete(l23_tag)
l24_tag = findobj('tag','l24');
delete(l24_tag)
l33_tag = findobj('tag','l33');
delete(l33_tag)
l34_tag = findobj('tag','l34');
delete(l34_tag)

%

StrFitResult_tag1 = findobj('tag','StrFitResult1');
delete(StrFitResult_tag1)
StrFitResult_tag2 = findobj('tag','StrFitResult2');
delete(StrFitResult_tag2)
StrFitResultBin_tag1 = findobj('tag','StrFitResultBin1');
delete(StrFitResultBin_tag1)
StrFitResultBin_tag2 = findobj('tag','StrFitResultBin2');
delete(StrFitResultBin_tag2)

StrBField_tag = findobj('tag','StrBField');
delete(StrBField_tag)

dualcursor off

guidata(gcbo,h)

end