Fs=8000;
recorder = audiorecorder(Fs,16,1);
disp('Start speaking.');
recordblocking(recorder, 1.5);
disp('End of recording');
A2=getaudiodata(recorder);
sound(A2,Fs)

plot(A2)
   
    M=M/abs(max(M));
 A=A/abs(max(A));
    A2=A2/abs(max(A2));
    M2=M2/abs(max(M2));


maxlags= round(numel(A)*0.5);
[corrA,lagsA]=xcorr(A,A,maxlags);
[corrM,lagsM]=xcorr(M,M);
[corrx,lagsx]=xcorr(M,A,maxlags);

plot(A); hold on;
plot(A2);
plot(corrA); hold on;
plot(corrx);
plot(corrAord); hold on;
plot(corrxord);

[~,df] = findpeaks(corrA,'MinPeakDistance',5*2*24*10);
[~,mf] = findpeaks(corrA);
figure
plot(lagsA/(2*24),corrA,'k',...
     lagsA(df)/(2*24),corrA(df),'kv','MarkerFaceColor','r')
grid on

[~,df] = findpeaks(corrx,'MinPeakDistance',5*2*24*10);
[~,mf] = findpeaks(corrx);
figure
plot(lagsx/(2*24),corrx,'k',...
     lagsx(df)/(2*24),corrx(df),'kv','MarkerFaceColor','r')
grid on





corrAord=sort(corrA);
corrxord=sort(corrx);


L=length(corrAord);
v=100;
vi=1000+v;
mA=(corrAord(L-v)-corrAord(L-vi))/(vi-v);
mx=(corrxord(L-v)-corrxord(L-vi))/(vi-v);
pnc=(mx/mA)*100
