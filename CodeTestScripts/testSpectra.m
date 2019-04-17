function RunIssues = testSpectra(data,RunIssues)

% function RunIssues = testSpectra()
%
% Tests the wave resource functions and identifies any issues with the 
% functionality and calculations
%
% Input:
%   Data            A structure that contains the data used in the testing
%                   of the MHKiT functions
%   RunIssues       A structure that logs any issues encourntered during
%                   testing of the power performance scripts
% Output:
%   RunIssues       A structure that logs any issues encourntered during
%                   testing of the wave resource module scripts
% Dependencies
%   CalcWaveSpectrum, frequencyMoment, waveNumber, KfromW, 
%   OmniDirEnergyFlux, initWaveSpectra
%
% Usage
%   RunIssues = testSpectra(LoadData)
%   runs the wave resource module test scripts using data and logging
%   and issues in RunIssues


parameters = initParameters();
parameters.waterDensity = data.d1.waterDensity;  % density of water
parameters.waterDepth   = data.d1.waterDepth;   % water depth
freqRange = data.d1.freqRange;

% running the test scripts and evaluating the results
disp('Test 1');
% calculate the wave energy spectra, test 1, no optional parameters
waveSpectra1 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),data.d1.time(4000:end-4000),1024,50);

disp('Test 2');
% calculate the wave energy spectra, test 2, parameters structure
waveSpectra2 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),data.d1.time(4000:end-4000),1024,50,parameters);

disp('Test 3');
% calculate the wave energy spectra, test 3, freqRange
waveSpectra3 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),data.d1.time(4000:end-4000),1024,50,freqRange);

disp('Test 4');
% calculate the wave energy spectra, test 4, parameters and freqRange
waveSpectra4 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),data.d1.time(4000:end-4000),1024,50,parameters,freqRange);

disp('Test 5');
% calculate the wave energy spectra, test 5, parameters and freqRange
% reversed in location
waveSpectra5 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),data.d1.time(4000:end-4000),1024,50,freqRange,parameters);

disp('Test 6');
% calculate the wave energy spectra, test 6, deep water
waveSpectra6 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),data.d1.time(4000:end-4000),1024,50,'D');

disp('Test 7');
% calculate the wave energy spectra, test 7, deep water
waveSpectra7 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),data.d1.time(4000:end-4000),1024,50,parameters,'D');

disp('Test 8');
% calculate the wave energy spectra, test 8, deep water
waveSpectra8 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),data.d1.time(4000:end-4000),1024,50,parameters,freqRange,'D');

disp('Test 9');
% calculate the wave energy spectra, test 9, deep water
waveSpectra9 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),data.d1.time(4000:end-4000),1024,50,freqRange,parameters,'D');

disp('Test 10');
% calculate the wave energy spectra, test 9, deep water
waveSpectra10 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),data.d1.time(4000:end-4000),1024,50,'D',freqRange,parameters);

disp('Test 11');
% calculate the wave energy spectra, test 9, deep water
waveSpectra10 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),data.d1.time(4000:end-4000),1024,50,1,freqRange,parameters,0.95);

for i = 1:10
    eval(['RunIssues.evalData(1,' num2str(i) ') = waveSpectra'  num2str(i) '.props.TimeSeriesDuration;']);
    eval(['RunIssues.evalData(2,' num2str(i) ') = waveSpectra'  num2str(i) '.props.numSamples;']);
    eval(['RunIssues.evalData(3,' num2str(i) ') = waveSpectra'  num2str(i) '.props.sampleRate;']);
    eval(['RunIssues.evalData(4,' num2str(i) ') = waveSpectra'  num2str(i) '.environment.waterDepth;']);
    eval(['RunIssues.evalData(5,' num2str(i) ') = waveSpectra'  num2str(i) '.environment.waterDensity;']);
    eval(['RunIssues.evalData(6,' num2str(i) ') = waveSpectra'  num2str(i) '.environment.g;']);
    eval(['RunIssues.evalData(7,' num2str(i) ') = waveSpectra'  num2str(i) '.stats.Hm0;']);
    eval(['RunIssues.evalData(8,' num2str(i) ') = waveSpectra'  num2str(i) '.stats.Tp;']);
    eval(['RunIssues.evalData(9,' num2str(i) ') = waveSpectra'  num2str(i) '.stats.Te;']);
    eval(['RunIssues.evalData(10,' num2str(i) ') = waveSpectra'  num2str(i) '.stats.T0;']);
    eval(['RunIssues.evalData(11,' num2str(i) ') = waveSpectra'  num2str(i) '.stats.Tm;']);
    eval(['RunIssues.evalData(12,' num2str(i) ') = waveSpectra'  num2str(i) '.stats.Te;']);
    eval(['RunIssues.evalData(13,' num2str(i) ') = waveSpectra'  num2str(i) '.stats.e;']);
    eval(['RunIssues.evalData(14,' num2str(i) ') = waveSpectra'  num2str(i) '.stats.v;']);
    
end;

%[waveSpectra.Spectrum,waveSpectra.frequency] = pwelch(detrend(wave1(4000:end-4000)), hanning(N),0, N, 50);

figure(1);
subplot(2,1,1);
plot(data.d1.time(4000:end-4000),data.d1.wave1(4000:end-4000));
subplot(2,1,2);
plot(1./waveSpectra1.frequency,waveSpectra1.Spectrum,1./waveSpectra2.frequency,waveSpectra2.Spectrum,1./waveSpectra3.frequency,waveSpectra3.Spectrum,1./waveSpectra4.frequency,waveSpectra4.Spectrum);