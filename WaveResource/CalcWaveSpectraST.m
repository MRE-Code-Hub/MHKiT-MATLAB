function waveSpectra = CalcWaveSpectrumST(waveElevation,dateTime,parameters,varargin)

% waveSpectra = CalcWaveSpectrum(waveElevation,dateTime,parameters,deepWaterFlag, timeRange)
%
% Calculates the wave energy spectrum of a time series and populates the
% waveSpectra MHKiT structure.
%
% Input:
%   waveElevation           Time Series of wave elevation (m)
%   dateTime                a vector containing the time series of the
%                           date and time represented in days since January 1, 0000.
%                           Use Matlab function DateNumber() to create this
%                           input
%   parameters              MHKiT structure of various parameters
%   deepWaterFlag (optional)a flag that forces deep water calculations, to
%                           set the flag, include 'D' in the input
%                           arguments
%    timeRange (optional)   Two element vector [T1, T2] (s) that bound the
%                           calculations, where T1 is the time where the
%                           calculations will start and T2 is the time
%                           where the calculations will stop. If empty,
%                           then the calculations are performed over
%                           the entire time series.This variable should
%                           alos be made from the DateNumber() function. 
%
% Output:
%   waveSpectra             MHKiT structure that contains all of the data
%                           and metadata for the wave spectra calculation
%
% Dependencies
%   Matlab Toolboxes:
%   Signal Processing
%
%   MHKiT Matlab files:
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

if isstruct(parameters)
    % checking for the parameters structure to be passed
    if ~strcmp(parameters.structType,'Parameters')
        ME = MException('MATLAB:CalcWaveSpectrumST','Invalid input, parameters must by struture of type Parameters');
        throw(ME);
    end;
else
    ME = MException('MATLAB:CalcWaveSpectrumST','Invalid input, parameters must by struture of type Parameters');
    throw(ME);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting the function variables
sampleRate          = parameters.data.sampleRate;
NFFT                = parameters.spectrum.NFFT;
spectTimeLngth      = parameters.spectrum.spectTimeLngth;
spectraTimeSpacing  = parameters.spectrum.spectraTimeSpacing;
freqRange           = parameters.spectrum.freqRange;
confLimit           = parameters.spectrum.confInterval;
waterDepth          = parameters.environemnt.waterDepth;
waterDensity        = parameters.environemnt.waterDensity;
g                   = parameters.environemnt.g;
freqIdxSt           = [];
freqIdxEd           = [];

% default is one spectrum calculated from the entire time series, this is
% changed later if spectraTimeSpacing and/or spectTimeLngth are set
startIdx            = 1;
endIdx              = length(waveElevation);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% checking input variables
if nargin > 5
    ME = MException('MATLAB:CalcWaveSpectrumST','Incorrect number of input arguments, too many agruments, requires 5 at most, %d arguments passed',nargin);
    throw(ME);
end;

%check to see if the first input argumeent is a vector
if any([~isvector(waveElevation), ~isnumeric(waveElevation), length(waveElevation) == 1])
    ME = MException('MATLAB:CalcWaveSpectrumST','waveElevation must be a numeric vector with length > 1');
    throw(ME);
end;

%check to see if the second input argumeent is a vector
if any([~isvector(dateTime), ~isnumeric(dateTime), length(dateTime) == 1])
    ME = MException('MATLAB:CalcWaveSpectrumST','dateTime must be a numeric vector with length > 1');
    throw(ME);
end;

%check to see if the second input argument is a vector
%increasing
if any([~isvector(dateTime), ~isnumeric(dateTime),length(dateTime) == 1])
    ME = MException('MATLAB:CalcWaveSpectrumST','dateTime must be a numeric vector with length > 1');
    throw(ME);
end;

% check to see if the time vector is the same length as the elevation
% vector
if length(dateTime) ~= length(waveElevation)
    ME = MException('MATLAB:CalcWaveSpectrumST','waveElevation and dateTime must be the same length');
    throw(ME);
end;

%check to see if the NFFT is a single integer
if any([length(NFFT) > 1,~isnumeric(NFFT), mod(NFFT,1) ~= 0, NFFT <= 0])
    ME = MException('MATLAB:CalcWaveSpectrumST','NFFT must be an integer greater than 0');
    throw(ME);
end;

%check to see if sampleRate is a single number greater than 0
if any([length(sampleRate) > 1, ~isnumeric(sampleRate), sampleRate <= 0])
    ME = MException('MATLAB:CalcWaveSpectrumST','SampleRate must be an number greater than 0');
    throw(ME);
end;

%check to see if spectTimeLngth is a single number greater than 0 at at
%least NFFT/samplerate long
if any([length(spectTimeLngth) > 1, ~isnumeric(spectTimeLngth), spectTimeLngth <= (NFFT/sampleRate)])
    ME = MException('MATLAB:CalcWaveSpectrumST','spectTimeLngth must be an number greater than NFFT/sampleRate');
    throw(ME);
end;

%check for a valid frequency range vector
if ~isempty(freqRange)
    if any([~isnumeric(freqRange), length(freqRange) ~= 2])
        ME = MException('MATLAB:CalcWaveSpectrumST','freqRange must be a vector of reals with a length of 2');
        throw(ME);
    elseif any([freqRange(1) > freqRange(2),min(freqRange) < 0])
        ME = MException('MATLAB:CalcWaveSpectrumST','freqRange values must be great than 0 with the second element greater than the first');
        throw(ME);
    end;
end;

%check for a valid confidence limit
if ~isempty(confLimit)
    if any([~isnumeric(confLimit), length(confLimit) ~= 1, confLimit >= 1, confLimit <= 0 ])
        ME = MException('MATLAB:CalcWaveSpectrumST','confLimit must be a number between 0 and 1');
        throw(ME);
    end;
end;

% check to see if ave Period - the length of time between spectra
if any([length(spectraTimeSpacing) > 1, ~isnumeric(spectraTimeSpacing), spectraTimeSpacing < spectTimeLngth])
    ME = MException('MATLAB:CalcWaveSpectrumST','spectraTimeSpacing must be an number greater than or equal to spectTimeLngth');
    throw(ME);
end;

% parsing out and assigning the variables from the input arguments,
% assuming that they may occur in any order
if nargin > 3
    for indx = 4:1:nargin
        if varargin{indx-3}== 'D'
            waterDepth = inf;
        elseif all([isnumeric(varargin{indx-3}), length(varargin{indx-3}) == 2])
            % checking to see if the input is the start and stop range vector
            if all([min(varargin{indx-3}) >= 0, (varargin{indx-3}(2) > varargin{indx-3}(1))])
                timeRange = varargin{indx-3};
                
                % finding the indices for the specrtal calculations
                startIdx = find(dateTime >= timeRange(1),1);
                if any([isempty(startIdx), (timeRange(1)-dateTime(1))*24*3600 < -1/sampleRate])
                    ME = MException('MATLAB:CalcWaveSpectrumST','start time is not within the range of dateTime');
                    throw(ME);
                end;
                endIdx   = find(dateTime >= timeRange(2),1);
                if isempty(endIdx)
                    ME = MException('MATLAB:CalcWaveSpectrumST','end time is not within the range of dateTime');
                    throw(ME);
                end;
            else
                ME = MException('MATLAB:CalcWaveSpectrumST','timeRange must be vector with two elements with the second element larger than the first');
                throw(ME);
            end
        else
            ME = MException('MATLAB:CalcWaveSpectrumST','Invalid input arguments, unrecongnized flag or input argument');
            throw(ME);
        end;
    end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% determining the indexing into the time series for the spectra
% calcualtions

if ~isempty(spectraTimeSpacing)
    % the total span of time between the starting index of each time
    % series segment is specified, therefore, the starting location of
    % each time series segment is specified
    NumDataPointsSpecSpac   = spectraTimeSpacing*sampleRate;
    startIdx = startIdx:NumDataPointsSpecSpac:(endIdx-NumDataPointsSpecSpac+1);
    if ~isempty(spectTimeLngth)
        % spectTimeLngth is specified, therefore mapping the endIdx to the
        % specified length of each time series used to calculate each
        % spectrum
        NumDataPointsPerSpec    = spectTimeLngth*sampleRate;
        endIdx = startIdx+NumDataPointsPerSpec-1;
    else
        % spectTimeLngth not specified, therefor assume the whole
        % NumDataPointsSpecSpac window is used to calculate each spectrum
        endIdx = startIdx+NumDataPointsSpecSpac-1;
    end;
elseif ~isempty(spectTimeLngth)
    % Since the time span between the starting index of each time segment
    % is NOT specified, assume the time span between segments is equal to
    % the specified length of each time series used to calcualte each
    % spectrum
    NumDataPointsPerSpec    = spectTimeLngth*sampleRate;
    startIdx = startIdx:NumDataPointsPerSpec:(endIdx-NumDataPointsPerSpec+1);
    endIdx   = startIdx+NumDataPointsPerSpec-1;
end;



% assigning the metadata for the spectra structure

% Initiating a waveSpectra MHKiT structure
waveSpectra = initWaveSpectra();

% spectra properties
waveSpectra.freqBinWidth                = sampleRate/NFFT;
waveSpectra.freqSpacing                 = 'uniform';
waveSpectra.props.sampleRate            = sampleRate;
waveSpectra.props.spectTimeLngth        = spectTimeLngth;
waveSpectra.props.NFFT                  = NFFT;
waveSpectra.props.freqRange             = freqRange;
waveSpectra.props.confInterval          = confLimit;
waveSpectra.props.NumSpecInAve          = floor((endIdx(1)- startIdx(1)+1)/NFFT);

% environment and position properties
waveSpectra.environment.waterDepth      = waterDepth;
waveSpectra.environment.waterDensity    = waterDensity;
waveSpectra.environment.gamma           = 1;
waveSpectra.environment.g               = g;
waveSpectra.props.latitude              = [];
waveSpectra.props.longitude             = [];

% Calculating the spectra
%dateTime(startIdx)*24*3600;
%dateTime(endIdx)*24*3600;

% calculating the spectra

% forward alocating vaiables

m = NFFT/2+1;
n = length(startIdx);
waveSpectra.frequency               = zeros(m,n);
waveSpectra.spectrum                = zeros(m,n);
waveSpectra.freqBinWidth            = zeros(m,1);
waveSpectra.Upper95Conf             = zeros(m,n);
waveSpectra.Lower95Conf             = zeros(m,n);
waveSpectra.dateTime                = zeros(1,n);
waveSpectra.k                       = [];



for specIndx = 1:length(startIdx)
    
    waveSpectra.dateTime(specIndx) = dateTime(startIdx(specIndx));
    
    %startIdx(specIndx):endIdx(specIndx)
    if isempty(confLimit)
        [waveSpectra.frequency(:,specIndx), waveSpectra.spectrum(:,specIndx), freqBinWidth] = CalcWaveSpectrum(waveElevation(startIdx(specIndx):endIdx(specIndx)), ...
            NFFT, sampleRate);
    else
        if length(waveElevation(startIdx(specIndx):endIdx(specIndx)))/NFFT >= 2
            [waveSpectra.frequency(:,specIndx), waveSpectra.spectrum(:,specIndx), freqBinWidth, confLimits] = CalcWaveSpectrum(waveElevation(startIdx(specIndx):endIdx(specIndx)), ...
                NFFT, sampleRate, confLimit);
            waveSpectra.Upper95Conf(:,specIndx) = confLimits(:,1);
            waveSpectra.Lower95Conf(:,specIndx) = confLimits(:,2);
        else
            ME = MException('MATLAB:CalcWaveSpectrumST','too few degrees of freedom to calculate the confidence interval. Increase the length of the time series so that the ratio of samples/NFFT >= 2');
            throw(ME);
        end;
    end;
    
    if isempty(waveSpectra.k)
        % calculating the wave numbers
        waveSpectra.k = KfromF(waveSpectra.frequency(:,specIndx),parameters);
    end;
    
    
    %determining the index into the frequency vector
    if isempty(freqIdxSt)
        if ~isempty(freqRange)
            freqIdxSt = find(waveSpectra.frequency(:,specIndx) <= freqRange(1),1,'last');
            freqIdxEd = find(waveSpectra.frequency(:,specIndx) >= freqRange(2),1);
            
        else
            freqIdxSt = 1;
            freqIdxEd = length(waveSpectra.frequency(:,specIndx));
        end;
    end;
    
    % calculating the wave spectral moments
    waveMoments                         = CalcWaveMoments(waveSpectra.frequency(:,specIndx), ...
        waveSpectra.spectrum(:,specIndx), freqBinWidth);
    waveSpectra.stats.Hm0(specIndx)     = waveMoments.Hm0;
    waveSpectra.stats.Te(specIndx)      = waveMoments.Te;
    waveSpectra.stats.T0(specIndx)      = waveMoments.T0;
    waveSpectra.stats.Tc(specIndx)      = waveMoments.Tc;
    waveSpectra.stats.Tm(specIndx)      = waveMoments.Tm;
    waveSpectra.stats.Tp(specIndx)      = waveMoments.Tp;
    waveSpectra.stats.e(specIndx)       = waveMoments.e;
    waveSpectra.stats.v(specIndx)       = waveMoments.v;
    
    % calculating the wave energy flux
    waveSpectra.stats.J(specIndx)       = OmniDirEnergyFlux(waveSpectra.frequency(:,specIndx),...
        waveSpectra.spectrum(:,specIndx),parameters,'freqBinWidth', ...
        freqBinWidth, 'k', waveSpectra.k);
    %
end;
waveSpectra.freqBinWidth        = freqBinWidth;

%waveSpectra.







