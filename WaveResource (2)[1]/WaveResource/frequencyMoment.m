function m = frequencyMoment(waveSpectra,N,varargin)
% calculates the Nth frequency moment of the variance spectrum S
% for vector F whos elements are evenly spaced, this is, where
% delta F is a constant.
%
% S: Spectral Density (unit^2/Hz)
% F: Frequency Vector (Hz)
% N: Moment (0 for 0th, 1 for 1st ....)
%

% check to see if the correct number of arguments are being passed
if nargin < 2
    error('frequencyMoment: Incorrect number of input arguments, requires at least 2 arguments');
end;
if nargin > 3
    error('frequencyMoment: Incorrect number of input arguments, too many agruments, requires 3 at most');
end;

% checking for the waveSpectra structure to be passed
if isstruct(waveSpectra)
    if waveSpectra.structType   ~= 'waveSpectra'
        error('frequencyMoment: Invalid Structure input, first argument must by type waveSpectra');
    end;
else
    error('frequencyMoment: Invalid Structure input, first argument must by type waveSpectra');
end;

% checking that N is a scalar
if ~(isscalar(N))
    error('frequencyMoment: N must be a scalar');
end;

% checking that the Spectrum and Fequency are vectors
if (isscalar(waveSpectra.Spectrum) | isscalar(waveSpectra.frequency))
    error('frequencyMoment: one or more inputs are not vectors');
end;

% checking to see if the Spectrum and Frequency are the same length
if (length(waveSpectra.Spectrum) ~= length(waveSpectra.frequency))
    error('frequencyMoment: vectors must be the same length');
end;

% check for evenly spaced frequency vector
x = linspace(waveSpectra.frequency(1),waveSpectra.frequency(end),length(waveSpectra.frequency));
tmpa = size(waveSpectra.frequency);
tmpb = size(x);
if tmpa(1) == tmpb(1);
    if ~all(abs(waveSpectra.frequency-x)<=abs(eps(x))*2)
        disp('frequencyMoment: frequency vector is not evenly spaced');
    end;
else
    if ~all(abs(waveSpectra.frequency-x')<=abs(eps(x))*2)
        disp('frequencyMoment: frequency vector is not evenly spaced');
    end;
end;

% checking for positive frequencies
if any(waveSpectra.frequency < 0)
    error('frequencyMoment: negative frequencies are included in the frequency vector, only postive values are allowed');
end;

if nargin == 3
    if ~isscalar(varargin{1}) & isvector(varargin{1})
        % checking to see if the input is the frequency range vector
        if min(varargin{1}) > 0 & length(varargin{1}) == 2
            waveSpectra.props.FreqRange = varargin{1};
        elseif length(varargin{1}) ~= 2
            error('frequencyMoment: Invalid input argument, freqRange must be a vector of length 2');
        else
            error('frequencyMoment: Invalid input argument, freqRange values must be greater than 0');
        end;
    end;
end;



% delta F
delF = waveSpectra.bandwidth;

% calculating the moment
if ~isempty(waveSpectra.props.freqRange)
    % calculate the frequency moment for a limited frequency range
    
    % finding the first and last index for the frequrency range
    firstIdx = find(waveSpectra.frequency <= waveSpectra.props.freqRange(1),1,'last');
    lastIdx  = find(waveSpectra.frequency >= waveSpectra.props.freqRange(2),1,'first');
    
    if (waveSpectra.frequency(firstIdx) ~= 0)
        m = sum(waveSpectra.Spectrum(firstIdx:lastIdx).*(waveSpectra.frequency(firstIdx:lastIdx).^N)*delF);
    else
        m = sum(waveSpectra.Spectrum(2:end).*(waveSpectra.frequency(2:end).^N)*delF);
    end;       
else
    if (waveSpectra.frequency(1) ~= 0)
        m = sum(waveSpectra.Spectrum.*(waveSpectra.frequency.^N)*delF);
    else
        m = sum(waveSpectra.Spectrum(2:end).*(waveSpectra.frequency(2:end).^N)*delF);
    end;
end;
