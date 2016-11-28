clc;
clear;
close all;

% read in file, y is the number of samples, fs is the sampling frequency
[y,fs] = audioread('jimmielunceford_excerpt.wav');
n = length(y);
% % play sound
% sound(y,fs);

% apply A law!!!!
b = 8;       % bitrate
r = range(y);% range of signal
q = r/(2^b); % quantization range
A = 87.56;   % parameter A

q_int = min(y):q:max(y);

% normalize to 1
y_a = y./(max(y));
y_b = y_a;
minvalue = 1/A;
maxvalue = 1;

% A law forward transform
for i = 1:n;
    if (abs(y_a(i))>= minvalue) && (abs(y_a(i))<= maxvalue)
        y_b(i) = sign(y_a(i))*(1+log(A*abs(y_a(i))))/(1 + log(A));
    elseif abs(y_a(i))<1/A
        y_b(i) = sign(y_a(i))*A*abs(y_a(i))/(1 + log(A));
    end
end

% quantization, truncation
y_c = floor(y_b./q);
y_d = y_c.* q;

% Inverse A law
y_e = y_d;
for j = 1:n;
    if abs(y_d(j))< 1/(1+log(A))
        y_e(j) = sign(y_d(j))*abs(y_d(j))*(1+log(A))/A;
    elseif abs(y_d(j)) <= 1 && abs(y_d(j)) >= 1/(1+log(A))
        y_e(j) = sign(y_d(j))*exp(abs(y_d(j))*(1+log(A))-1)/...
            (A*(1+ log(A)));
    end      
end

uniqueValuesInQuantizedSignal = unique(y_d);
% denormalize
y_f = y_e.*max(y);
%plot(y_f);
%audiowrite('~/utsa_2fall2016/DSP_EE5163/FINAL PROJECT/jl_alaw_8bit.wav', y_f, fs);
%sound(y_f,fs);
% % % plot original waveform
t=[1/fs : 1/fs : n/fs];
figure(1)
axis equal tight;
plot(t,y);

rms_y = sqrt(mean(y.^2));

noise = y - y_f;

rms_n = sqrt(mean(noise.^2));

snr_yf= (rms_y/rms_n)^2;


