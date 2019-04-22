function waveSpectra = CalcWaveSpectrum(waveElevation,waveTime,NFFT,sampleRate,varargin)

% waveSpectra = CalcWaveSpectrum(waveSpectra,parameters,freqRange,deepWaterFlag, confLimit)
%
% Calculates the wave energy spectrum of a time series and populates the
% waveSpectra MHKiT structure.
%
% Input:
%   waveElevation           Time Series of wave elevation (m)
%   waveTime                Wave Elevation time vector (s) 
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
%   deepWaterFlag (optional)a flag that forces deep water calculations, to  
%                           set the flag, include 'D' in the input
%                           arguments 
%
%   confLimit (optional)    if a confidence interval is needed, include a
%                           number between 0 and 1, where 1 is 100% and 0
%                           is 0%. For example, 0.95 is 95% confidence
%                           interval
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
%   CalcWaveSpectrum(waveSpectra,NFFT,sampleRate,'D')
%   Calculates the spectrum and wave statistics using the deep water 
%   assumption and using default gravity and water density. The statistics
%   are calculated over all frequencies.
%
% Version 1, 11/25/2018 Rick Driscoll, NREL and Bradley Ling, Northwest Energy Innovations

% Initiating a waveSpectra MHKiT structure
waveSpectra = initWaveSpectra();

% check to see if the correct number of arguments are being passed
if nargin < 4
    ME = MException('MATLAB:CalcWaveSpectrum','Incorrect number of input arguments, requires at least 4 arguments, only %d arguments passed',nargin);
    throw(ME);
end;

if nargin > 8
    ME = MException('MATLAB:CalcWaveSpectrum','Incorrect number of input arguments, too many agruments, requires 8 at most, %d arguments passed',nargin);
    throw(ME);    
end;

%check to see if the first input argumeent is a vector
if any([~isvector(waveElevation), ~isnumeric(waveElevation), length(waveElevation) == 1])
    ME = MException('MATLAB:CalcWaveSpectrum','waveElevation must be a numeric vector with length > 1');
    throw(ME);    
end;

%check to see if the second input argument is a vector and is monotonically
%increasing
if any([~isvector(waveTime), ~isnumeric(waveTime),length(waveTime) == 1])
    ME = MException('MATLAB:CalcWaveSpectrum','waveTime must be a numeric vector with length > 1');
    throw(ME);    
end;

% check to see if the time vector is the same length as the elevation
% vector
if length(waveTime) ~= length(waveElevation)
    ME = MException('MATLAB:CalcWaveSpectrum','waveElevation and waveTime must be the same length');
    throw(ME);    
end;

%check to see if the second input is a single integer
if any([length(NFFT) > 1,~isnumeric(NFFT), mod(NFFT,1) ~= 0, NFFT <= 0])
    ME = MException('MATLAB:CalcWaveSpectrum','NFFT must be an integer greater than 0');
    throw(ME);
end;

%check to see if the thrid input is a single number greater than 0
if any([length(sampleRate) > 1, ~isnumeric(sampleRate), sampleRate <= 0])
    ME = MException('MATLAB:CalcWaveSpectrum','SampleRate must be an number greater than 0');
    throw(ME);
end;

% parsing out and assigning the variables from the input arguments,
% assuming that they may occur in any order
if nargin > 4
    for indx = 5:1:nargin
        % if more than 3 arguments passed, then loop through and parse the
        % data out of the optional arguments
        if isstruct(varargin{indx-4})
            % checking for the parameters structure to be passed
            parameters = varargin{indx-4};
            if parameters.structType   == 'Parameters'
                waveSpectra.environment.waterDepth      = parameters.waterDepth;
                waveSpectra.environment.waterDensity    = parameters.waterDensity;
                waveSpectra.environment.g               = parameters.g;
            else
                error('CalcWaveSpectrum: Invalid Structure input, must by type Parameters');
            end;
        elseif ~isscalar(varargin{indx-4}) & isvector(varargin{indx-4})
            % checking to see if the input is the frequency range vector
            if min(varargin{indx-4}) > 0 & length(varargin{indx-4}) == 2
                waveSpectra.props.freqRange = varargin{indx-4};
            elseif length(varargin{indx-4}) ~= 2
                error('CalcWaveSpectrum: Invalid input argument, freqRange must be a vector of length 2');
            else
                error('CalcWaveSpectrum: Invalid input argument, freqRange values must be greater than 0');
            end;
        elseif varargin{indx-4}== 'D'
            waveSpectra.environment.waterDepth = inf;
        elseif isscalar(varargin{indx-4}) & varargin{indx-4} >=0 & varargin{indx-4} <=1
            waveSpectra.props.confInterval = varargin{indx-4};
        else
            error('CalcWaveSpectrum: Invalid input arguments, unrecongnized flag or input argumjent');
        end;
    end;
end;

% Calculating the spectra
if  isempty(waveSpectra.props.confInterval)
    [waveSpectra.Spectrum,waveSpectra.frequency] = pwelch(detrend(waveElevation), hanning(NFFT),[] , NFFT, sampleRate);
else
    %calculate spectra with confidence interval
    if length(waveElevation)/NFFT >= 2
    [waveSpectra.Spectrum,waveSpectra.frequency,ConfLimits] = pwelch(detrend(waveElevation), hanning(NFFT),[] , NFFT, sampleRate,'ConfidenceLevel',waveSpectra.props.confInterval);
    waveSpectra.Upper95Conf = ConfLimits(:,1);
    waveSpectra.Lower95Conf = ConfLimits(:,2);
    else
        error('CalcWaveSpectrum: too few degrees of freedom to calculate the confidence interval. Increase the length of the time series so that the ratio of samples/NFFT >= 2');
    end;
end;

% filling in the metadata for the spectra
waveSpectra.bandwidth                   = sampleRate/NFFT;
waveSpectra.props.numSamples            = NFFT;
waveSpectra.props.sampleRate            = sampleRate;
waveSpectra.props.TimeSeriesDuration    = sampleRate*(length(waveElevation)-1);

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


