[data,header]=loadTimeSeriesAsciiData('/Users/rpauly/Documents/ValidationData/SPOT #7.dat','\t',18);
time=data(:,2);
torque=[data(:,3),data(:,3)];
angle=[data(:,27),data(:,27)];
anglerad=deg2rad(angle);
daytime=time;
wave1=data(18000:35999,20)*0.0254;
waterDensity = 1000;
waterDepth = 5.1;
freqRange = [0.2 2];

TDMSFile='/Users/rpauly/Documents/testData/NWEI/NWEI_Offshore_data_20180315/NWEI_OfS_10Hz_data_20180315_0430.tdms';
outTD=TDMS_getStruct(TDMSFile);

parametersd1 = initParameters();
parametersd1.environemnt.waterDensity       = waterDensity;  % density of water
parametersd1.environemnt.waterDepth         = waterDepth;   % water depth
parametersd1.spectrum.freqRange             = freqRange;
parametersd1.data.sampleRate                = 50;
parametersd1.spectrum.NFFT                  = 1024;
parametersd1.spectrum.spectTimeLngth        = 60;
parametersd1.spectrum.spectraTimeSpacing    = 120;
parametersd1.spectrum.confInterval          = [];


samplerate=1/(time(2)-time(1));
%powerdata=CalcPowerDC(torque,anglerad,time,samplerate);
powerdata=CalcPowerWindow(outTD.Time_Domain.Vdc_V.data',outTD.Time_Domain.Idc_A.data',outTD.Time_Domain.Time.data',samplerate,outTD.Time_Domain.Time.data',parametersd1);
waveSpectra = CalcWaveSpectraST(wave1,outTD.Time_Domain.Time.data',parametersd1);
captureLength = CalcCaptureLength(powerdata.power.avg,waveSpectra.stats.J,powerdata.dateTime(:,1));
[capLengthMatrix,HmoBins,TeBins] = CalcCaptureLengthMatrix(captureLength,powerdata.dateTime(:,1),waveSpectra.stats.Hm0,waveSpectra.stats.Te,0.5,1.0,...
      0.0,7.5,0.0,18.0);
plot=CaptureLengthMatrixPlot(capLengthMatrix(:,:,1),HmoBins(1,:),TeBins(1,:),["Mean"]);
