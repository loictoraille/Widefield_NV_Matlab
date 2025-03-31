function FuncAutoFocusPiezo(hobject)
global NI_card TestWithoutHardware

if TestWithoutHardware~=1 && exist('NI_card','var') && any(isprop(NI_card,'Running')) && ~isempty(daqlist)

set(hobject.autofocuspiezo,'ForegroundColor',[0,0,1]);

[Opt_Z, z_out, foc_out, Shift_Z, fit_z_successful] = FuncIndepAutofocusPiezo(hobject);

set(hobject.autofocuspiezo,'ForegroundColor',[0,0,0]);
set(hobject.autofocuspiezo,'Value',0);

else
    disp('NI_card was not found, check if it is plugged in and turned on, then restart Matlab');
end

end