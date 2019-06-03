[data,header]=loadTimeSeriesAsciiData('/Users/rpauly/Documents/ValidationData/SPOT #7.dat','\t',18);
time=data(:,2);
torque=[data(:,3),data(:,3)];
angle=[data(:,27),data(:,27)];
anglerad=degtorad(angle);
daytime=time;

samplerate=1/(time(2)-time(1));
%powerdata=CalcPowerDC(torque,anglerad,time,samplerate);
powerdata=CalcPowerWindow(torque,anglerad,time,samplerate,daytime,500);



