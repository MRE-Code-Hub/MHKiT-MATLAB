function RunIssues = testSpectra(varargin)

% function RunIssues = testPowerPerformace(LoadData)
%
% Executes the power performance scripts and verifies the functions. This
% function identifies any issues with the functionality and calculations
%
% Input:
%   LoadData(optional)        flag to determine whether to force the data
%                             to load (boolean). The test data are
%                             automatically loaded on the first run;
%                             however, this flag is used if those data need
%                             need to be reloaded.
% Output:
%   RunIssues       A structure that logs any issues encourntered during
%                   testing of the power performance scripts
% Dependencies
%   CalcWaveSpectrum, frequencyMoment, waveNumber, KfromW, 
%   OmniDirEnergyFlux
%
% Usage
%   RunIssues = testPowerPerformace(LoadData)
%   runs the power performance module test scripts. The test data are
%   automatically loaded on the first run, however, if LoadData = 1, the
%   test data are reloaded


% Initalizing variables

% setting path
BaseDirectory = 'C:\Users\fdriscol\Desktop\Topic Area 5 Matlab\Processing Scripts';
addpath(genpath(BaseDirectory),'-begin')

% Specifiying the metadata
parameters = initParameters();
parameters.waterDensity = 1000;  % density of water
parameters.waterDepth   = 5.1;   % water depth
freqRange = [0.2 2];

% loading the data that is used in the function testing
persistent data;
loadData = 0;
if nargin == 1
    if varargin{1} == 1
        loadData = 1;
    end;
else
    if isempty(data)
        loadData = 1;
    end;
end;
if loadData
    disp('Loading WEP Data');
    dataSets = [8,9];
    filenames = [{'SPOT #7.dat'},{'SPOT #8.dat'},{'SPOT #9.dat'}, ...
        {'SPOT #10.dat'},{'SPOT #11.dat'},{'SPOT #12.dat'},{'SPOT #17.dat'}, ...
        {'SPOT #18.dat'},{'SPOT #19.dat'},{'SPOT #20.dat'},{'SPOT #21.dat'},...
        {'SPOT #22.dat'},{'SPOT #23.dat'},{'SPOT #26.dat'},{'SPOT #27.dat'},...
        {'SPOT #29.dat'},{'SPOT #37.dat'},{'SPOT #38.dat'},{'SPOT #40.dat'},...
        {'SPOT #42.dat'},{'SPOT #43.dat'},{'SPOT #44.dat'},{'SPOT #45.dat'}, ...
        {'SPOT #47.dat'},{'SPOT #48.dat'},{'SPOT #49.dat'},{'SPOT #50.dat'}];
    % step through and load each spot data file number contained in dataSets
    for setIdx = 1:length(dataSets)
        % loading the individual data file
        eval(['[data.d' num2str(setIdx) '.data, header] = loadTimeSeriesAsciiData([filenames{' num2str(dataSets(setIdx)) '}],''\t'',18);']);
        
        % getting rid of the nan created by the leading tab
        eval(['data.d' num2str(setIdx) '.data = data.d' num2str(setIdx) '.data(:,2:end);']);
        eval(['data.d' num2str(setIdx) '.time = data.d' num2str(setIdx) '.data(:,1);']);
        eval(['data.d' num2str(setIdx) '.sampleRate = 1/(data.d' num2str(setIdx) '.time(2) - data.d' num2str(setIdx) '.time(1));']);
        eval(['data.d' num2str(setIdx) '.kin = data.d' num2str(setIdx) '.data(:,26);']);
        eval(['data.d' num2str(setIdx) '.dyn = data.d' num2str(setIdx) '.data(:,2);']);
        eval(['data.d' num2str(setIdx) '.wave1 = data.d' num2str(setIdx) '.data(:,20)*0.0254;']);
        eval(['data.d' num2str(setIdx) '.wave2 = data.d' num2str(setIdx) '.data(:,21)*0.0254;']);
    end;
end;

% running the test scripts and evaluating the results

disp('Test 1');
% calculate the wave energy spectra, test 1, no optional parameters
waveSpectra1 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),1024,50);

disp('Test 2');
% calculate the wave energy spectra, test 2, parameters structure
waveSpectra2 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),1024,50,parameters);

disp('Test 3');
% calculate the wave energy spectra, test 3, freqRange
waveSpectra3 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),1024,50,freqRange);

disp('Test 4');
% calculate the wave energy spectra, test 4, parameters and freqRange
waveSpectra4 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),1024,50,parameters,freqRange);

disp('Test 5');
% calculate the wave energy spectra, test 5, parameters and freqRange
% reversed in location
waveSpectra5 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),1024,50,freqRange,parameters);

disp('Test 6');
% calculate the wave energy spectra, test 6, deep water
waveSpectra6 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),1024,50,1);

disp('Test 7');
% calculate the wave energy spectra, test 7, deep water
waveSpectra7 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),1024,50,parameters,1);

disp('Test 8');
% calculate the wave energy spectra, test 8, deep water
waveSpectra8 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),1024,50,parameters,freqRange,1);

disp('Test 9');
% calculate the wave energy spectra, test 9, deep water
waveSpectra9 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),1024,50,freqRange,parameters,1);

disp('Test 10');
% calculate the wave energy spectra, test 9, deep water
waveSpectra10 = CalcWaveSpectrum(data.d1.wave1(4000:end-4000),1024,50,1,freqRange,parameters);


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