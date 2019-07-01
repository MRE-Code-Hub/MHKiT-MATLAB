function J = OmniDirEnergyFlux(waveSpectra,varargin)

% J = OmniDirEnergyFlux(waveSpectra,parameters,deepWaterFlag)
%
% Calculates the omnidirectional wave energy flux based on IEC/TS
% 62600-100 Ed. 1.0, 2012-08 using equation 5, page 15.
%
% If the deepWaterFlag is not set and if a watrer depth is specified in
% either of the waveSpectra or parameters structures, the group velocity
% is calculated using equations 6 and 7 on page 15. If deepWaterFlag
% is set or the water depth in infinite, deep water is
% assumed and equation 8 on page 15 is used.
%
% Input:
%   waveSpectra             MHKiT structure that contains all of the data
%                           and metadata for the wave spectra calculatione
%   freqRange (optional)    Two element vector [F1, F2] that bound the
%                           spectral calculations, where F1 is the lower
%                           frequency limit and F2 is the upper frequency
%                           limit
%   deepWaterFlag (optional)a flag that forces deep water calculations, 
%                           set flat to 'D' for deep water
%
% Output:
%   J                             omnidirectional wave energy flux (W/m)
%
% Dependencies
%   waveNumber, KfromW
%
% Usage
%   OmniDirEnergyFlux(waveSpectra)
%   calculates the omnidirection wave energy flux using deep water
%   assumption and using default gravity and water
%   density.
%
%   OmniDirEnergyFlux(waveSpectra,'D')
%   calculates the omnidirection wave energy flux for deep water
%   using default gravity and water density.
%
% Version 1, 11/25/2018 Rick Driscoll, NREL and Bradley Ling, Northwest Energy Innovations

if nargin > 3
    error('OmniDirEnergyFlux: Incorrect number of input arguments, too many agruments, requires 3 at most');
end;

% checking for the waveSpectra structure to be passed
if isstruct(waveSpectra)
    if waveSpectra.structType   ~= 'waveSpectra'
        error('OmniDirEnergyFlux: Invalid Structure input, first argument must by type waveSpectra');
    end;
else
    error('OmniDirEnergyFlux: Invalid Structure input, first argument must by type waveSpectra');
end;

% error checking prior to starting script
% checking the QA flag
if waveSpectra.qaFlag ~= 0
    % If the qaFlag isnt zero, dont perform calculation
    error('OmniDirEnergyFlux: qaFlag for waveSpectra is set');
end

% checking that the Spectrum and Fequency are vectors
if (isscalar(waveSpectra.Spectrum) | isscalar(waveSpectra.frequency))
    error('OmniDirEnergyFlux: one or more inputs are not vectors');
end;

% the spectrum and frequency must be the same length
if length(waveSpectra.Spectrum) ~= length(waveSpectra.frequency)
    error('OmniDirEnergyFlux: vectors spectrum and frequency must be the same length');
end;

% check for evenly spaced frequency vector
x = linspace(waveSpectra.frequency(1),waveSpectra.frequency(end),length(waveSpectra.frequency));
tmpa = size(waveSpectra.frequency);
tmpb = size(x);
if tmpa(1) == tmpb(1);
    if ~all(abs(waveSpectra.frequency-x)<=abs(eps(x))*2)
        disp('OmniDirEnergyFlux: frequency vector is not evenly spaced');
    end;
else
    if ~all(abs(waveSpectra.frequency-x')<=abs(eps(x))*2)
        disp('OmniDirEnergyFlux: frequency vector is not evenly spaced');
    end;
end;

% checking for positive frequencies
if any(waveSpectra.frequency < 0)
    error('OmniDirEnergyFlux: negative frequencies are included in the frequency vector, only postive values are allowed');
end;

if isempty(waveSpectra.environment.waterDensity)
    error('OmniDirEnergyFlux: Density not specified, using default');
    waveSpectra.environment.waterDensity    = 1025;
end;
if isempty(waveSpectra.environment.g)
    error('OmniDirEnergyFlux: Gravitational accleration not specified, using default');
    waveSpectra.environment.g               = 9.81;
end;

if isempty(waveSpectra.environment.waterDepth)
    error('OmniDirEnergyFlux: Water depth not specified, using deep water');
    waveSpectra.environment.waterDepth      = inf;
end;

% parsing out and assigning the variables from the input arguments
if nargin > 1
    for indx = 2:1:nargin
        % if more than 2 arguments passed, then loop through and parse the
        % data out of the optional arguments
        if ~isscalar(varargin{indx-1}) & isvector(varargin{indx-1})
            % checking to see if the input is the frequency range vector
            if min(varargin{indx-1}) > 0 & length(varargin{indx-1}) == 2
                if ~isempty(waveSpectra.props.freqRange)
                    waveSpectra.props.freqRange = varargin{indx-1};
                else
                    error('OmniDirEnergyFlux: freqRange already set, cannot overwrite it');
                end;
                
            elseif length(varargin{indx-1}) ~= 2
                error('OmniDirEnergyFlux: Invalid input argument, freqRange must be a vector of length 2');
            else
                error('OmniDirEnergyFlux: Invalid input argument, freqRange values must be greater than 0');
            end;
        elseif varargin{indx-1}== 'D'
            % deep water specified, overwriting the water depth
            waveSpectra.environment.waterDepth = inf;
        else
            error('OmniDirEnergyFlux: Invalid input arguments, unrecongnized flag or input argumjent');
        end;
    end;
end;

% Initalizing commly accessed variables
h   = waveSpectra.environment.waterDepth;
rho = waveSpectra.environment.waterDensity;
g   = waveSpectra.environment.g;

% Calculating the omnidirectional wave energy flux.
if ~isinf(h)
    % Water depth is specified, so calculate the group velocity based on
    % the specified water depth
    
    % check to see if h is a valid depth
    if any([~isreal(h), h < 0])
        error('OmniDirEnergyFlux: Invalid water depth');
    end
    
    % determining the first and last index of the specturm to calculate the
    % omnidirectional wave energy flux
    if isempty(waveSpectra.props.freqRange)
        % no frequency range specified, using full range of frequencies,
        % excluding the first value if its zero
        disp('no freq range specified');
        lastIdx = numel(waveSpectra.frequency);
        if  waveSpectra.frequency(1) ~= 0
            firstIdx = 1
        else
            firstIdx = 2;
        end;
    else
        % determining the indices that span the frequency range
        % finding the first and last index for the frequrency range
        firstIdx = find(waveSpectra.frequency <= waveSpectra.props.freqRange(1),1,'last');
        lastIdx  = find(waveSpectra.frequency >= waveSpectra.props.freqRange(2),1,'first');
    end;
    
    % Calculate wave number
    waveSpectra.k = waveNumber(waveSpectra);
    
    % calculating the group velocity, based on IEC TS 62600-100
    Cp = sqrt(g*tanh(h*waveSpectra.k(firstIdx:lastIdx))./waveSpectra.k(firstIdx:lastIdx));
    Cg = Cp/2.*(1+(2*h*waveSpectra.k(firstIdx:lastIdx))./sinh(2*h*waveSpectra.k(firstIdx:lastIdx)));
    
    % calculating the wave energy flux
    J  = rho*g*sum(waveSpectra.bandwidth.*waveSpectra.Spectrum(firstIdx:lastIdx).*Cg);
else
    % Deep water calculation, if water depth is not specified, deep water
    % is the default
    
    if isempty(waveSpectra.stats.Te)
        %calculating the wave energy period
        error('OmniDirEnergyFlux: wave energy peroid not specified, terminating');
        return;
    else
        Te = waveSpectra.stats.Te;
    end;
    if isempty(waveSpectra.stats.Hm0)
        % calculating the significant wave height
        error('OmniDirEnergyFlux: significant wave height not specified, terminating');
        return;
    else
        Hm0 = waveSpectra.stats.Hm0;
    end;
    J = rho*g*g/64/pi*Hm0*Hm0*Te;
end;


