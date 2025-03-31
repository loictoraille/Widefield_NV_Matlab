function StopContinuousTempReading(src, ~)

    set(src,'ForegroundColor',[0 1 0]);

    StopContinuousTempReadingFunc();

    set(src,'ForegroundColor',[0 0 0]);

end
