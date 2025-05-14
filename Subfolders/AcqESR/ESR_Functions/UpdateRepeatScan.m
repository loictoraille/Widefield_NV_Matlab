function UpdateRepeatScan(hobject,~)

RepeatScan = str2double(hobject.String);

if RepeatScan < 1
    RepeatScan = 1;
    hobject.String = num2str(RepeatScan);
end

UpdateAcqParam();

end