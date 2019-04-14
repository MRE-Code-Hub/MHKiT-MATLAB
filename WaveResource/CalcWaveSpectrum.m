function waveSpectra = CalcWaveSpectrum(waveTimeSeries,NFFT,sampleRate,varargin)

% waveSpectra = OmniDirEnergyFlux(waveSpectra,parameters,freqRange,deepWaterFlag)
%
% Calculates the wave energy spectrum of a time series and populates the
% waveSpectra MHKiT structure.
%
% Input:
%   waveTimeSerie           wave elevation time series (m)
%   NFFT                    number of bins in the FFT (integer)
%   sampleRate              sample rate of the wave elevation time series
%                           (Hz)
%   parameters (optional)   MHKiT structure (optional), these values will
%                           specify the water density, water depth, and
%                           gravity parameters, otherwise, default values
%                           are used
%   freqRange (optional)    Two element vector [F1, F2] that bound the
%                           spectral calculations, where F1 is the lower
%                           frequency limit and F2 is the upper frequency
%                           limit
%   deepWaterFlag (optional)a flag that forces deep water calculations, 1 =
%                           deep water
%
% Output:
%   waveSpectra             MHKiT structure that contains all of the data
%                           and metadata for the wave spectra calculation
%
% Dependencies
%   frequencyMoment, waveNumber, KfromW, OmniDirEnergyFlux, 
%   initWaveSpectra
%
% Usage
%   CalcWaveSpectrum(waveSpectra,NFFT,sampleRate)
%   Calculates the spectrum and wave statistics using the deep water 
%   assumption and using default gravity and water density. The statistics
%   are calculated over all frequencies
%   
%   CalcWaveSpectrum(waveSpectra,NFFT,sampleRate,parameters)
%   calculates the spectrum and wave statistics using the values for 
%   water depth, gravity and water density specified in the paraeters
%   structure. The statistics are calcluated over all frequencies
%
%   CalcWaveSpectrum(waveSpectra,NFFT,sampleRate,freqRange)
%   calculates the spectrum and wave statistics using the deep water 
%   assumption and using default gravity and water density. The statistics
%   are calcluated between the frequency range specired by freqRange
%
%   CalcWaveSpectrum(waveSpectra,NFFT,sampleRate,deepWaterFlag)
%   Calculates the spectrum and wave statistics using the deep water 
%   assumption and using default gravity and water density. The statistics
%   are calculated over all frequencies.
%
% Version 1, 11/25/2018 Rick Driscoll, NREL and Bradley Ling, Northwest Energy Innovations

% Initiating a waveSpectra MHKiT structure
waveSpectra = initWaveSpectra();

% check to see if the correct number of arguments are being passed
if nargin < 3
    error('CalcWaveSpectrum: Incorrect number of input arguments, requires at least 3 arguments');
end;

if nargin > 6
    error('CalcWaveSpectrum: Incorrect number of input arguments, too many agruments, requires 6 at most');
end;

%check to see if the first input is a time series
if ~isvector(waveTimeSeries)
    error('CalcWaveSpectrum: waveTimeSeries must be a vector');
end;

%check to see if the second input is a single integer
if ~isvector(NFFT) | mod(NFFT,1) ~= 0 | NFFT <= 0
    error('CalcWaveSpectrum: NFFT must be an integer greater than 0');
end;

%check to see if the thrid input is a single number greater than 0
if ~isvector(NFFT) | ~isnumeric(sampleRate) | sampleRate <= 0
    error('CalcWaveSpectrum: sampleRate must be an number greater than 0');
end;

% parsing out and assigning the variables from the input arguments,
% assuming that they may occur in any order
if nargin > 3
    for indx = 4:1:nargin
        % if more than 3 arguments passed, then loop through and parse the
        % data out of the optional arguments
        if isstruct(varargin{indx-3})
            % checking for the parameters structure to be passed
            parameters = varargin{indx-3};
            if parameters.structType   == 'Parameters'
                waveSpectra.environment.waterDepth      = parameters.waterDepth;
                waveSpectra.environment.waterDensity    = parameters.waterDensity;
                waveSpectra.environment.g               = parameters.g;
            else
                error('CalcWaveSpectrum: Invalid Structure input, must by type Parameters');
            end;
        elseif ~isscalar(varargin{indx-3}) & isvector(varargin{indx-3})
            % checking to see if the input is the frequency range vector
            if min(varargin{indx-3}) > 0 & length(varargin{indx-3}) == 2
                waveSpectra.props.freqRange = varargin{indx-3};
            elseif length(varargin{indx-3}) ~= 2
                error('CalcWaveSpectrum: Invalid input argument, freqRange must be a vector of length 2');
            else
                error('CalcWaveSpectrum: Invalid input argument, freqRange values must be greater than 0');
            end;
        elseif varargin{indx-3}== 1
            waveSpectra.environment.waterDepth = inf;
        else
            error('CalcWaveSpectrum: Invalid input arguments, unrecongnized flag or input argumjent');
        end;
    end;
end;

% Calculating the spectra
[waveSpectra.Spectrum,waveSpectra.frequency] = pwelch(detrend(waveTimeSeries), hanning(NFFT),[] , NFFT, sampleRate);

% filling in the metadata for the spectra
waveSpectra.bandwidth                   = sampleRate/NFFT;
waveSpectra.props.numSamples            = NFFT;
waveSpectra.props.sampleRate            = sampleRate;
waveSpectra.props.TimeSeriesDuration    = sampleRate*(length(waveTimeSeries)-1);

% Significant wave height
waveSpectra.stats.Hm0 = 4*sqrt(frequencyMoment(waveSpectra,0));

% Wave Energy period
waveSpectra.stats.Te = frequencyMoment(waveSpectra,-1)/frequencyMoment(waveSpectra,0);

% Average zero crossing period
waveSpectra.stats.T0 = sqrt(frequencyMoment(waveSpectra,0)/frequencyMoment(waveSpectra,2));

% Average peak to peak period
waveSpectra.stats.Tc = frequencyMoment(waveSpectra,2)/frequencyMoment(waveSpectra,4);

% Mean wave period
waveSpectra.stats.Tm = frequencyMoment(waveSpectra,0)/frequencyMoment(waveSpectra,1);

% Peak Period
[val,peakIdx] = max(waveSpectra.Spectrum);
waveSpectra.stats.Tp = 1/waveSpectra.frequency(peakIdx);

% Spectral bandwidth, 
waveSpectra.stats.e = sqrt(1- (frequencyMoment(waveSpectra,2).^2)/(frequencyMoment(waveSpectra,0)/frequencyMoment(waveSpectra,4)));

% Spectral width, Longuet-Higgins’s spectral width (1975)
waveSpectra.stats.v = sqrt(frequencyMoment(waveSpectra,0)*frequencyMoment(waveSpectra,2)/(frequencyMoment(waveSpectra,1).^2) - 1);

% Wave Energy Flux
waveSpectra.stats.J = OmniDirEnergyFlux(waveSpectra);


