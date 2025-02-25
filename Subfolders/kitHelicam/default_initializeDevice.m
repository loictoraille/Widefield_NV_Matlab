function [] = default_initializeDevice(c4dev)
 % simple configuration example of heliCam C8 using internal reference
    % signal
    
    % Experiment Parameters
    
    
    % Lock-In Amplification (LIA)
    
    % Sensor sensitivity in %/100, 0.5 for C4-S40, 0.2 for C4-S40U, 0.05 for C4-S41U and 0.25 for C4M
    sensitivity = 0.5;
    % Number of intergration periods
    NPeriods = 10;
    % Background suppression on/off switch, 'AC' or 'DC'
    coupling = 'DC';
    % Reference frequency in Hz
    refFrequency = 10000.0;
    % Source of reference signal, 'Internal' or 'External'
    refSource = 'Internal';
    % Expected frequency deviation of external reference input in %
    expFrequencyDev = 5;
    
    % Illumination Driving Signal
    
    % Signal generator DC offset in % of full range
    sgnOffset = 20.0;
    % Signal generator peak-to-peak amplitude in % of full range
    sgnAmplitude = 10.0;
    % Signal generator frequency in Hz
    sgnFrequency = 9975.0;
    
    
    % Configuration
    
    % Trigger
    
    c4dev.writeString("TriggerSelector", "RecordingStart");
    c4dev.writeString("TriggerMode", "Off");
    c4dev.writeString("TriggerSelector", "FrameStart");
    c4dev.writeString("TriggerMode", "On");
    c4dev.writeString("TriggerSource", "Software");
    
    % LIA
    
    c4dev.writeString("DeviceOperationMode", "LockInCam");
    c4dev.writeString("Scan3dExtractionMethod", "rawIQ");
    
    c4dev.writeFloat("LockInSensitivity", sensitivity);
    c4dev.writeInteger("LockInTargetTimeConstantNPeriods", NPeriods);
    c4dev.writeString("LockInCoupling", coupling);
    c4dev.writeInteger("LockInExpectedFrequencyDeviation", expFrequencyDev);
    c4dev.writeFloat("LockInTargetReferenceFrequency", refFrequency);
    
    c4dev.writeString("LockInReferenceSourceType", refSource);
    
    % For external reference signal only
    c4dev.writeString("LockInReferenceFrequencyScaler", "Off");
    c4dev.writeString("LockInReferenceSourceSignal", "FI2");
    
    % Illumination
    
    c4dev.writeFloat("SignalGeneratorOffset", sgnOffset);
    c4dev.writeFloat("SignalGeneratorAmplitude", sgnAmplitude);
    c4dev.writeString("LightControllerSelector", "LightController0");
    c4dev.writeString("SignalGeneratorMode", "On");
    c4dev.writeFloat("SignalGeneratorFrequency", sgnFrequency);
    c4dev.writeString("LightControllerSource", "SignalGenerator");
    
    
    % Read feature values from camera
    
    ActualRefFrequency = c4dev.readFloat("LockInActualReferenceFrequency");

    fprintf('The actual Reference Frequency :  %0.2f Hz\n',ActualRefFrequency)

end
