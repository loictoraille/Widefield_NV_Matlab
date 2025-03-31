function StopContinuousTempReading(src, ~)

    set(src,'ForegroundColor',[0 0 1]);

    StopContinuousTempReadingFunc();

    set(src,'ForegroundColor',[0 0 0]);

end
