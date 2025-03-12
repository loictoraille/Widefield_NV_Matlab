
function FuncCameraRanges(h)
global ObjCamera CameraType TestWithoutHardware

if ~TestWithoutHardware

%% Exposure time
ExpRange = GetExpRange();
Exp = GetExp();
[Exp,ExpUnit] = GetExp();

PrintRange = ExpRange;
PrintRange.Minimum = max(ExpRange.Minimum,Exp/10);
PrintRange.Maximum = min(ExpRange.Maximum,Exp*10);

h.sldexp.Min=PrintRange.Minimum;%Min value of slider updated
h.expmin.String=round(PrintRange.Minimum,3);%Printed/text min value of slider rounded to 3 digits & updated
h.sldexp.Max=PrintRange.Maximum;%Max value of slider updated
h.expmax.String=round(PrintRange.Maximum,3);%Printed/text max value of slider rounded to 3 digits & updated
h.sldexp.Value=Exp;%Current value of slider updated
h.exptext.String=['Exposure = ', num2str(round(Exp,3)),' ' ExpUnit];%Printed/text Current value of slider rounded to 3 digits & updated
h.Input_Exp.String = num2str(round(Exp,3));

%% Frame rate
FraRange = GetFrameRateRange();
Fra = GetFrameRate();

h.sldframe.Min=FraRange.Minimum;%Min value of slider updated
h.framin.String=round(FraRange.Minimum,3);%Printed/text min value of slider rounded to 3 digits & updated
h.sldframe.Max=FraRange.Maximum;%Max value of slider updated
h.framax.String=round(FraRange.Maximum,3);%Printed/text max value of slider rounded to 3 digits & updated
if Fra>FraRange.Maximum
    Fra = FraRange.Maximum;
end
h.sldframe.Value=Fra;%Current value of slider updated
h.fratext.String=['Frame Rate = ', num2str(round(Fra,3)),' Hz'];%Printed/text Current value of slider rounded to 3 digits & updated
h.Input_FrameRate.String = num2str(round(Fra,3));

%% Pixel clock
PixRange = GetPixelClockRange();
Pix = GetPixelClock();

h.sldpix.Min=PixRange.Minimum;%Min value of slider updated
h.pixmin.String=PixRange.Minimum;%Printed/text min value of slider rounded to 3 digits & updated
h.sldpix.Max=PixRange.Maximum;%Max value of slider updated
h.pixmax.String=PixRange.Maximum;%Printed/text max value of slider rounded to 3 digits & updated
h.sldpix.Value=Pix;%Current value of slider updated
h.pixtext.String=['Pixel Clock = ', num2str(Pix),' MHz'];%Printed/text Current value of slider & updated
h.Input_PixelClock.String = num2str(Pix);

end
end
