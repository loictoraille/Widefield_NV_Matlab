clc; clear all; close all;

if ~NET.isNETSupported
    disp('Supported .NET Framework not found')
    return
end

NET.addAssembly('C4HdlCLR');
import C4HdlCLR.*

disp('*************************************************')
disp('* Matlab example c4DemodSimple based on C4HdlCLR *')
disp('*************************************************')

% establish camera connection
c4sys = heliotis.C4HandlerCLR();
c4sys.reset();
ifNo = selectInterface(c4sys);
c4if = c4sys.openInterface(ifNo);
devNo = selectDevice(c4if);
c4dev = c4if.openDevice(devNo);

% configure camera and wait for LED output
fprintf('initializing camera...\n')
initializeDevice(c4dev)
pause(3) %in seconds
fprintf('... done')

% enter camera acquisition mode
c4dev.startAcquisition(4)

% launch frame start trigger
c4dev.executeCommand("TriggerSoftware");

% load measurement data from buffer
c4buf = c4dev.getBuffer(10000);

% retrieve rawI and rawQ component
NFrames = c4buf.readInteger("ChunkPartCount")/2;
frameDimension = c4buf.getPartDimension(1);
width = frameDimension(1);
height = frameDimension(2);

rawI = zeros(NFrames,height,width);
rawQ = zeros(NFrames,height,width);

for i=0:NFrames-1

    rawI(i+1,:,:) = transpose(reshape(double(c4buf.getDataPartUint16(i)),width,height));
    rawQ(i+1,:,:) = transpose(reshape(double(c4buf.getDataPartUint16(i+NFrames)),width,height));

end

rawI = (mod(rawI, 2^15)) / 2^2;
rawQ = (mod(rawQ, 2^15)) / 2^2;

% Discard initial frames lacking information
NFramesDiscard = 3;

I = rawI(NFramesDiscard:NFrames,:,:);
Q = rawQ(NFramesDiscard:NFrames,:,:);

% (Optionally) remove the offset (simple time average per pixel)
removeOffset = true;

if removeOffset

    I = I - mean(I, 1);
    Q = Q - mean(Q, 1);

end

% plot measurement data
plotData(I,Q)

% release buffer
c4buf.release();

% stop acquisition
c4dev.stopAcquisition();

% release resources
c4dev.release()
c4if.release()

function ifNo = selectInterface(c4sys)
    % interface selection with user interaction
    ifNo = -1;
    disp('Interfaces: ')
    nofIf = c4sys.updateInterfaceList();
    if (nofIf == 0)
        disp('No interface detected!');
        return
    end
    for i = 0:(nofIf-1)
        curIfName = c4sys.getInterfaceName(i);
        disp(num2str(i + 1) + ": " + string(curIfName));
    end
    val = input('select an interface (exit with any other value): ');
    if ((val <= 0) || (val > nofIf))
        disp('Interface selection is out of range!');
        return
    end
    ifNo = (val - 1);
end

function devNo = selectDevice(c4if)
    % device selection with user interaction 
    devNo = -1;
    disp('Device: ')
    nofDev = c4if.updateDeviceList();
    if (nofDev == 0)
        disp('No device detected!');
        return
    end
    for i = 0:(nofDev-1)
        curDevName = c4if.getDeviceName(i);
        disp(num2str(i + 1) + ": " + string(curDevName));
    end
    val = input('select a device (exit with any other value): ');
    if ((val <= 0) || (val > nofDev))
        disp('Device selection is out of range!');
        return
    end
    devNo = (val - 1);
end

function initializeDevice(c4dev)
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

    fprintf('Actual Reference Frequency :  %0.2f Hz\n',ActualRefFrequency)

end

function plotData(I,Q)
    % plot the measured data


    % plot time series of selected pixels

    xs = [100, 454];
    ys = [100, 412];
    cs = ['r','b'];
    
    NFrames = size(I,1);
    
    for i = 1:length(xs)
    
        subplot(2,2,i);
        plot(1:NFrames,I(:,xs(i),ys(i)),Color=cs(i),LineStyle="-")
        hold on
        plot(1:NFrames,Q(:,xs(i),ys(i)),Color=cs(i),LineStyle=":")
        hold on
        
        legend('I','Q')
        xlabel('frame number')
        ylabel('I/Q')
        title(['point ' num2str(i) ' (x=' num2str(xs(i)) ',y=' num2str(ys(i)) ')'])
        
    
    end
    

    % plot root mean square (rms) amplitude across field of view

    rms = squeeze(sqrt(mean(I.^2 + Q.^2)));
    
    subplot(2,2,[3,4])
    
    imagesc(rms)
    colorbar
    hold on
    
    for i = 1:length(xs)
    
        plot(xs(i),ys(i),Color=cs(i),Marker='+',MarkerSize=15,LineWidth=2);
        hold on
    
    end
    
    xlabel('x in pxl')
    ylabel('y in pxl')
    title('rms amplitude')
    
    hold off

end
