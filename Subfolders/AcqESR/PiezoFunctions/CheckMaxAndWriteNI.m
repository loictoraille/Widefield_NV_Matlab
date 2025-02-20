function CheckMaxAndWriteNI(X_value, Y_value, Z_value, L_value)
global NI_card

if X_value < -10
    X_value = -10;
end
if X_value > 10
    X_value = 10;
end

if Y_value < -10
    Y_value = -10;
end
if Y_value > 10
    Y_value = 10;
end

if Z_value < 0
    Z_value = 0;
end
if Z_value > 10
    Z_value = 10;
end

write(NI_card,[X_value, Y_value, Z_value, L_value]);

pause(0.1);
    
end