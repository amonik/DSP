%My graphics hardware was causing mathlab crash, using software graphics
opengl('save', 'software');
%load the wav file
filename = 'jimmielunceford_excerpt.wav';
%Read it and sample it.
[signal,fs] = audioread(filename,'double');
n = length(signal);
%plot the wav file
rangeOfSignal = range(signal);
bitRate = 8;
quantizationRange = rangeOfSignal/(2^bitRate); % quantization range
quantizationInterval = min(signal):quantizationRange:max(signal);
minValue = -1;
maxValue = 1;
mu = 255; %vary this see what happens

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

figure
plot(t, signalRecover)
title('Recovered Signal');


figure
plot(t,signal)
title('Orignal Signal');

uniqueValuesInQuantizedSignal = unique(quantizedSignalFinal);
%sound(signal,fs);

%SignalNosieRatio

RMS_signal = sqrt(mean(signal.^2));

error = signal - signalRecover;

RMS_error = sqrt(mean(error.^2));

signalNoiseRatio = (RMS_signal/RMS_error)^2;

signalNoiseRatioDB = 10*log10(RMS_signal/RMS_error)^2;

%filtering







