function waveMoments = CalcWaveMoments(frequency, spectrum,  varargin)

% waveMoments = CalcWaveMoments(frequency, spectrum)
%
% Calculates the set of wave statistics that are commoly used in the MRE
% field. The calcluations are based on IEC/TS 62600-100 ed 1.0 2012-08,
% IEC/TS 62600-101 ed 1.0 2015-068, and other commonly used formulations
% when not avaialble in the standards.
%
% Input:
%   spectrum                spectral desnsity vector of the wave height
%                           time series (m^2/Hz)
%   frequency               frequency vector for the spectrum (Hz)
%   freqBinWidth (optional) vector of the frequency width of each spectral
%                           component. This vector must be the same length
%                           as the frequency vector. It can me uniformly or
%                           non-uniformly spaced frequencies
%
% Output:
%   waveMoments             structure of the wave spectral moments,spectral
%                           estimate of the significant wave height Hm0,
%                           wave Energy period Te, average zero crossing
%                           period T0, average peak to peak period Tc, mean
%                           wave period Tm, peak period Tp, spectral
%                           bandwidth e, spectral width v.
%
%
% Dependencies
%   Matlab Toolboxes:
%
%   MHKiT Matlab files:
%   frequencyMoment
%
% Usage
%   waveStats = CalcWaveMoments(frequency, spectrum)
%   Calculates the set of wave spectrum moments  that are commoly used in
%   the MRE field for a wave spectral desinsity with equal frequency
%   spacing.
%
% Version 1, 11/25/2018 Rick Driscoll, NREL

% check to see if the correct number of arguments are being passed
if nargin < 2
    ME = MException('MATLAB:CalcWaveMoments','Incorrect number of input arguments, requires at least 2 arguments, only %d arguments passed',nargin);
    throw(ME);
end;

if nargin > 3
    ME = MException('MATLAB:CalcWaveMoments','Incorrect number of input arguments, too many agruments, requires 3 at most, %d arguments passed',nargin);
    throw(ME);
end;


if nargin == 2  % perform checks and develop frequency spacing vector for 
                % spectrum with uniformly spaced frequencies

    % checking that the Spectrum and Fequency are vectors
    if any([isscalar(spectrum), isscalar(frequency),~isnumeric(spectrum), ~isnumeric(frequency)]);
        ME = MException('MATLAB:CalcWaveMoments','frequency and spectrum must both be vectors');
        throw(ME);
    end;
    
    % checking to see if the Spectrum and Frequency are the same length
    if (length(spectrum) ~= length(frequency))
        ME = MException('MATLAB:CalcWaveMoments','frequency and spectrum must be the same length');
        throw(ME);
    end;
    
    % check for evenly spaced frequency vector
    x = linspace(frequency(1),frequency(end),length(frequency));
    tmpa = size(frequency);
    tmpb = size(x);
    if tmpa(1) == tmpb(1);
        if ~all(abs(frequency-x)<=abs(eps(x))*2)
            ME = MException('MATLAB:CalcWaveMoments','frequency vector is not evenly spaced');
        throw(ME);
        end;
    else
        if ~all(abs(frequency-x')<=abs(eps(x))*2)
            ME = MException('MATLAB:CalcWaveMoments','frequency vector is not evenly spaced');
        throw(ME);
        end;
    end;
    
    
    
    % creating the uniformly spaced freqBinWidth vector
    freqBinWidth = ones(size(frequency))*mean(diff(frequency));
    
else % perform checks vector for spectrum with non-uniformly spaced 
     % frequencies
    
    freqBinWidth = varargin{1};
    
    % checking that the Spectrum, Fequency and freqBinWidth are vectors
    if any([isscalar(spectrum), isscalar(frequency), isscalar(freqBinWidth),~isnumeric(spectrum), ~isnumeric(frequency), ~isnumeric(freqBinWidth)]);
        ME = MException('MATLAB:CalcWaveMoments','frequency, spectrum and freqBinWidth must both be vectors');
        throw(ME);
    end;
    
    % checking to see if the Spectrum, Frequency and freqBinWidth vectors are
    % the same length
    if (length(spectrum) ~= length(frequency)) | (length(spectrum) ~= length(freqBinWidth))
        ME = MException('MATLAB:CalcWaveMoments','frequency, spectrum, and freqBinWidth must be the same length');
        throw(ME);
    end;
end;

% checking for positive frequencies
if any(frequency < 0)
    error('MATLAB:CalcWaveMoments','negative frequencies are included in the frequency vector, only postive values are allowed');
end;
if any(freqBinWidth < 0)
    error('MATLAB:CalcWaveMoments','negative frequencies are included in the freqBinWidth vector, only postive values are allowed');
end;



% Significant wave height per IEC/TS 62600-100, eqn 3 or IEC/TS 62600-101,
% eqn 12
waveMoments.Hm0 = 4*sqrt(frequencyMoment(frequency, spectrum, freqBinWidth, 0));

% Wave Energy period per IEC/TS 62600-100, eqn 4 or IEC/TS 62600-101,
% eqn 13
waveMoments.Te = frequencyMoment(frequency, spectrum, freqBinWidth,-1)/frequencyMoment(frequency, spectrum, freqBinWidth,0);

% Average zero crossing period per IEC/TS 62600-101, eqn 15
% eqn 12
waveMoments.T0 = sqrt(frequencyMoment(frequency, spectrum, freqBinWidth,0)/frequencyMoment(frequency, spectrum, freqBinWidth,2));

% Average peak to peak period
waveMoments.Tc = frequencyMoment(frequency, spectrum, freqBinWidth,2)/frequencyMoment(frequency, spectrum, freqBinWidth,4);

% Mean wave period
waveMoments.Tm = frequencyMoment(frequency, spectrum, freqBinWidth,0)/frequencyMoment(frequency, spectrum, freqBinWidth,1);

% Peak Period per IEC/TS 62600-101 % eqn 14
[val,peakIdx] = max(spectrum);
waveMoments.Tp = 1/frequency(peakIdx);

% Spectral bandwidth,
waveMoments.e = sqrt(1- (frequencyMoment(frequency, spectrum, freqBinWidth,2).^2)/(frequencyMoment(frequency, spectrum, freqBinWidth,0) ...
    /frequencyMoment(frequency, spectrum, freqBinWidth,4)));

% Spectral width per Longuet-Higgins’s spectral width (1975) or IEC/TS
% 62600-101 % eqn 16
waveMoments.v = sqrt(frequencyMoment(frequency, spectrum, freqBinWidth,0)*frequencyMoment(frequency, spectrum, freqBinWidth,-2) ...
    /(frequencyMoment(frequency, spectrum, freqBinWidth,-1).^2) - 1);
