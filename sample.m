%My graphics hardware was causing mathlab crash, using software graphics
opengl('save', 'software');
%load the wav file
filename = 'jimmielunceford.wav';
%Read it and sample it.
[signal,fs] = audioread(filename,'native');
%plot the wav file
t = linspace(0, length(signal)/fs, length(signal));
figure
plot(t,signal)
xlabel('time');



