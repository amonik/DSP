filename = 'AnitWhatYouDoByJimmieLunceford.mp3';
[signal,fs] = audioread(filename,'native');
t = linspace(0, length(signal)/fs, length(signal));
figure
plot(t,signal)
xlabel('time');
x = 14;
NFFT = 2^x;
f = linspace(0,fs,NFFT);
samples = abs(fft(signal,NFFT));
figure
plot(f(1:NFFT/2),samples(1:NFFT/2))
xlabel('Frequecy');


