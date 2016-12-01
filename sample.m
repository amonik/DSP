bitRate = 8; %vary and see what signal to noise Ratio will be
filterOrder = 10; %vary to see how changes filter
minValue = -1; %min Value of the Quanization
maxValue = 1; %Max Value of the Quanization
mu = 255; %vary this see what happens

%My graphics hardware was causing mathlab crash, using software graphics
opengl('save', 'software');
%load the wav file
filename = 'jimmielunceford_excerpt.wav';
%Read it and sample it.
[signal,fs] = audioread(filename,'double');
n = length(signal);
%plot the wav file
rangeOfSignal = range(signal);
quantizationRange = rangeOfSignal/(2^bitRate); % quantization range
quantizationInterval = min(signal):quantizationRange:max(signal);


%normaize
signalA = signal./(max(signal));
quantizedSignal = signalA;

%mu Quantization
for i = 1:n;
    if(signalA(i)>= minValue && signalA(i)<= maxValue)
        quantizedSignal(i) = sign(signalA(i))*(log(1 + mu*abs(signalA(i))))/(log(1 + mu));
    end
end

% quantization, truncation
quantizedSignalTrunc = floor(quantizedSignal./quantizationRange);
quantizedSignalFinal = quantizedSignalTrunc.* quantizationRange;

%Inverse Quantization
inverseQuantization = quantizedSignalFinal;

for j = 1:n;
    if(quantizedSignalFinal(j)>= minValue && quantizedSignalFinal(j)<= maxValue)
        inverseQuantization(j) = sign(quantizedSignalFinal(j))*(1/mu)*((1 + mu).^abs(quantizedSignalFinal(j)) - 1);
    end
end

signalRecover = inverseQuantization.*max(signal);

t = linspace(0, length(signal)/fs, length(signal));

uniqueValuesInQuantizedSignal = unique(quantizedSignalFinal);
%sound(signal,fs);

%SignalNosieRatio

RMS_signal = sqrt(mean(signal.^2));

error = signal - signalRecover;

RMS_error = sqrt(mean(error.^2));

signalNoiseRatio = (RMS_signal/RMS_error)^2;

signalNoiseRatioDB = 10*log10(RMS_signal/RMS_error)^2;

%filtering

%take FFT of signal
signalFreqency = abs(fft(signal));

[maxAmplitude,maxFrequency] = max(signalFreqency);
%Get the cutoff frequency
cutoffFrequency = (maxFrequency + (fs/2))*0.5;

%normalize cutoff frequency

cutoffFrequencyRadians = (2*cutoffFrequency)/fs;  

%apply butter low pass filter
[b,a] = butter(filterOrder,cutoffFrequencyRadians,'low');

filterRecoveredSignalLow = filter(b,a,quantizedSignalFinal);

%Apply High-pass filter
[d,c] = butter(filterOrder,cutoffFrequencyRadians,'high');
filterRecoveredSignalHigh = filter(d,c,quantizedSignalFinal);


figure(1)
plot(t,signal)
title('Orignal Signal');

figure(2)
plot(t, signalRecover)
title('Inverse Quantized Signal');

%plot Signal frequency
figure(3)
plot(t,signalFreqency)
title('frequency of signal');

%plot the quant signal and the low-pass filtered signal
figure(4)
freqz(b,a,128,fs);
title('Filter Charateristics Low-pass')

figure(5)
freqz(d,b,128,fs);
title('Filter Charateristics High-pass')

figure(6)
subplot(2,2,1),plot(quantizedSignalFinal),
title('Recover Data after Quantization with noise');
subplot(2,2,2),plot(filterRecoveredSignalLow),
title('Filtered Signal Low-pass')
subplot(2,2,3),plot(quantizedSignalFinal),
title('Recover Data after Quantization with noise');
subplot(2,2,4),plot(filterRecoveredSignalHigh),
title('Filtered Signal High-pass')









