function StopSaveContinuousTempReading(src, ~)

    set(src,'ForegroundColor',[0 0 1]);

    StopContinuousTempReadingFunc();
    SaveTemperatureDataFunc();

    set(src,'ForegroundColor',[0 0 0]);

end