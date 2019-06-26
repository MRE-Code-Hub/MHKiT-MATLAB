function freqMoment = frequencyMoment(frequency, spectrum, freqBinWidth, N)

% freqMoment = frequencyMoment(frequency, freqBinWidth, spectrum,N)
%
% calculates the Nth frequency moment of the spectrum and frequency. For
% unequal frequency spacing, freqBinWidth is required. For equal frequency
% spacing, freqBinWidth can be ommitted and the function will calculate it.
%
%   waveSpectra             Either a MHKiT waveSpectra structure or a
%                           wave spectrum (m^2/Hz). If a wave spectrum is
%                           passed, then a frequency vector is needed
%   frequency               frequency vector, only input if waveSpectra is
%                           a wave spectrum and not an MHKiT waveSpectra
%                           structure
%   freqBinWidth            vector of the frequency width of each spectral
%                           component. This vector must be the same length
%                           as the frequency vector. This input is required
%                           for unequal frequency spacing
%   N                       The order of the frequency moment to be
%                           calculated
%
%
%
%
%
% check to see if the correct number of arguments are being passed
if nargin < 3
    ME = MException('MATLAB:frequencyMoment','Incorrect number of input arguments, requires at least 3 arguments');
    throw(ME);
end;

% perform checks vector for spectrum with non-uniformly spaced
% frequencies

% checking that the Spectrum, Fequency and freqBinWidth are vectors
if any([isscalar(spectrum), isscalar(frequency), isscalar(freqBinWidth),~isnumeric(spectrum), ~isnumeric(frequency), ~isnumeric(freqBinWidth)]);
    ME = MException('MATLAB:frequencyMoment','frequency, spectrum and freqBinWidth must be vectors');
    throw(ME);
end;

% checking to see if the Spectrum, Frequency and freqBinWidth vectors are
% the same length
if (length(spectrum) ~= length(frequency)) | (length(spectrum) ~= length(freqBinWidth))
    ME = MException('MATLAB:frequencyMoment','frequency, spectrum, and freqBinWidth must be the same length');
    throw(ME);
end;

% checking for positive frequencies
if any(frequency < 0)
    error('MATLAB:frequencyMoment','negative frequencies are included in the frequency vector, only postive values are allowed');
end;

% checking that N is an integer
if (ischar(N)) | rem(N,1)~=0
    ME = MException('MATLAB:frequencyMoment','N must be an integer');
    throw(ME);
end;

if (frequency(1) ~= 0)
    freqMoment = sum(spectrum.*(frequency.^N).*freqBinWidth);
else
    freqMoment = sum(spectrum(2:end).*(frequency(2:end).^N).*freqBinWidth(2:end));
end;

