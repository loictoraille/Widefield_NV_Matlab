function StopSaveContinuousTempReading(src, ~)

    set(src,'ForegroundColor',[0 1 0]);

    StopContinuousTempReadingFunc();
    SaveTemperatureDataFunc();

    set(src,'ForegroundColor',[0 0 0]);

end