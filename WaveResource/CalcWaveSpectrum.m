function [frequency, spectrum, freqBinWidth, varargout] = CalcWaveSpectrum(waveElevation, NFFT, sampleRate, varargin)

% waveSpectra = CalcWaveSpectrum(waveSpectra, confLimit)
%
% Calculates the wave energy spectrum of a time series. This function uses
% a hanning window because of the broadband nature of waves.
%
% Note, at this time, this function only creates a spectrum that is equally
% spaced in frequency. In the future, it will be expanded to include equal
% energy frequency spacing and NDBC frequency spacing
%
% Input:
%   waveElevation           Time Series of wave elevation (m)
%   NFFT                    number of bins in the FFT (integer)
%   sampleRate              sample rate of the wave elevation time series
%                           (Hz)
%   confLimit (optional)    if a confidence interval is needed, include a
%                           number between 0 and 1, where 1 is 100% and 0
%                           is 0%. For example, 0.95 is 95% confidence
%                           interval%
%
% Output:
%   spectrum                spectral density of the wave height time series
%                           (m^2/Hz)
%   frequency               frequency vector for the spectrum (Hz)
%
%
% Dependencies
%   Matlab Toolboxes:
%   Signal Processing
%
%   MHKiT Matlab files:
%
%
% Usage
%   [frequency, spectrum] = CalcWaveSpectrum(waveElevation,NFFT,sampleRate)
%   Calculates the spectrum of a broadband wave signal
%
%   [frequency, spectrum, confLimits] = CalcWaveSpectrum(waveElevation,NFFT,sampleRate, confLimit)
%   Calculates the spectrum of a broadband wave signal and provides a the
%   upper and lower confidence limits.
%
% Version 1, 11/25/2018 Rick Driscoll, NREL and Bradley Ling, Northwest Energy Innovations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inital error checking of input data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check to see if the correct number of arguments are being passed
if nargin < 3
    ME = MException('MATLAB:CalcWaveSpectrum','Incorrect number of input arguments, requires at least 3 arguments, only %d arguments passed',nargin);
    throw(ME);
end;

if nargin > 4
    ME = MException('MATLAB:CalcWaveSpectrum','Incorrect number of input arguments, too many agruments, requires 4 at most, %d arguments passed',nargin);
    throw(ME);
end;

%check to see if the first input argumeent is a vector
if any([~isvector(waveElevation), ~isnumeric(waveElevation), length(waveElevation) == 1])
    ME = MException('MATLAB:CalcWaveSpectrum','waveElevation must be a numeric vector with length > 1');
    throw(ME);
end;

%check to see if the second input is a single integer
if any([length(NFFT) > 1,~isnumeric(NFFT), mod(NFFT,1) ~= 0, NFFT <= 0])
    ME = MException('MATLAB:CalcWaveSpectrum','NFFT must be an integer greater than 0');
    throw(ME);
end;

%check to see if the second input is a single number greater than 0
if any([length(sampleRate) > 1, ~isnumeric(sampleRate), sampleRate <= 0])
    ME = MException('MATLAB:CalcWaveSpectrum','SampleRate must be an number greater than 0');
    throw(ME);
end;

% assigning the variables from the input arguments, in this case, there is
% only 1.
confInterval = [];
if nargin > 3
    % if a forth input argument is specified, it must be the confidence
    % interval
    if isscalar(varargin{1}) & varargin{1} >=0 & varargin{1} <=1
        confInterval = varargin{1};
    else
        ME = MException('MATLAB:CalcWaveSpectrum','Invalid input arguments, input argumjent');
        throw(ME);
    end;
end;

% check to see if the correct number of output arguments has been specified
if (isempty(confInterval) & nargout> 3)
    ME = MException('MATLAB:CalcWaveSpectrum','Invalid number of output arguments, needs 3, however %d output arguments specified',nargout);
    throw(ME);
elseif (~isempty(confInterval) & nargout> 4)
    ME = MException('MATLAB:CalcWaveSpectrum','Invalid number of output arguments, needs 4, however %d output arguments specified',nargout);
    throw(ME);
end;

% Calculating the spectra
if  isempty(confInterval)
    [spectrum,frequency] = pwelch(detrend(waveElevation), hanning(NFFT),[] , NFFT, sampleRate);
else
    %calculate spectra with confidence interval
    if length(waveElevation)/NFFT >= 2
        [spectrum,frequency,confLimits] = pwelch(detrend(waveElevation), hanning(NFFT),[] , NFFT, sampleRate,'ConfidenceLevel',confInterval);
        % setting the output argument for the confidence limits
        varargout{1} = confLimits;
    else
        ME = MException('MATLAB:CalcWaveSpectrum','too few degrees of freedom to calculate the confidence interval. Increase the length of the time series so that the ratio of samples/NFFT >= 2');
        throw(ME);
    end;
end;

% calculating the frequency bin width for evenly spaced frequency vectors
freqBinWidth = ones(size(spectrum))*sampleRate/NFFT;


