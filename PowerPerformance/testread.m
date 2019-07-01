[data,header]=loadTimeSeriesAsciiData('/Users/rpauly/Documents/ValidationData/SPOT #7.dat','\t',18);
time=data(:,2);
torque=[data(:,3),data(:,3)];
angle=[data(:,27),data(:,27)];
%anglerad=deg2rad(angle);
%deltaang=angdiff(anglerad);
% deltaang=zeros(length(angle));
% diffang=diff(angle);
% % for i=2:length(deltaang)
% %     if (angle(i)-angle(i-1)) < 0.0 
% %         diffang(i)=diffang(i)+360;
% %     elseif (angle(i)-angle(i-1)) > 180
% deltatime=diff(time);
% angvel=deltaang./deltatime;
daytime=time;

parametersd1 = initParameters();
% parametersd1.environemnt.waterDensity       = data.d1.waterDensity;  % density of water
% parametersd1.environemnt.waterDepth         = data.d1.waterDepth;   % water depth
% parametersd1.spectrum.freqRange             = data.d1.freqRange;
parametersd1.data.sampleRate                = 50;
parametersd1.spectrum.NFFT                  = 1024;
parametersd1.spectrum.spectTimeLngth        = 60;
parametersd1.spectrum.spectraTimeSpacing    = 120;
parametersd1.spectrum.confInterval          = [];


samplerate=1/(time(2)-time(1));
%powerdata=CalcPowerDC(torque,anglerad,time,samplerate);
powerdata=CalcPowerWindow(torque,angle,time,samplerate,daytime,parametersd1);




