function J = OmniDirEnergyFlux(frequency, spectrum, parameters, varargin)

% J = OmniDirEnergyFlux(frequency, spectrum,parameters,deepWaterFlag,'freqBinWidth',freqBinWidth,'k',k)
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
%   spectrum                spectral desnsity vector of the wave height
%                           time series (m^2/Hz)
%   frequency               frequency vector for the spectrum (Hz)

%   parameters              MHKiT structure of various parameters
%   deepWaterFlag (optional)a flag that forces deep water calculations,
%                           set flat to 'D' for deep water
%   freqBinWidth (optional) vector of the frequency width of each spectral
%                           component. This vector must be the same length
%                           as the frequency vector. It can me uniformly or
%                           non-uniformly spaced frequencies
%   k  (optional)           wave number vector (1/m)
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

if nargin > 8
    ME = MException('MATLAB:OmniDirEnergyFlux','Incorrect number of input arguments, too many agruments, requires 8 at most');
    throw(ME);
end;

% checking that the Spectrum and Fequency are numbers
if any([isscalar(spectrum), isscalar(frequency),~isnumeric(spectrum), ~isnumeric(frequency)]);
    ME = MException('MATLAB:OmniDirEnergyFlux','frequency and spectrum must both be vectors');
    throw(ME);
end;

% checking to see if the Spectrum and Frequency are the same length
if (length(spectrum) ~= length(frequency))
    ME = MException('MATLAB:OmniDirEnergyFlux','frequency and spectrum must be the same length');
    throw(ME);
end;

% % check for evenly spaced frequency vector
% x = linspace(frequency(1),frequency(end),length(frequency));
% tmpa = size(frequency);
% tmpb = size(x);
% if tmpa(1) == tmpb(1);
%     if ~all(abs(frequency-x)<=abs(eps(x))*2)
%         ME = MException('MATLAB:OmniDirEnergyFlux','frequency vector is not evenly spaced');
%         throw(ME);
%     end;
% else
%     if ~all(abs(frequency-x')<=abs(eps(x))*2)
%         ME = MException('MATLAB:OmniDirEnergyFlux','frequency vector is not evenly spaced');
%         throw(ME);
%     end;
% end;

% checking for positive frequencies
if any(frequency < 0)
    ME = MException('MATLAB:OmniDirEnergyFlux','negative frequencies are included in the frequency vector, only postive values are allowed');
    throw(ME);
end;

% checking to make sure that parameters is a structure
if isstruct(parameters)
    % checking for the parameters structure to be passed
    if ~strcmp(parameters.structType,'Parameters')
        ME = MException('MATLAB:OmniDirEnergyFlux','Invalid input, parameters must by struture of type Parameters');
        throw(ME);
    end;
else
    ME = MException('MATLAB:OmniDirEnergyFlux','Invalid input, parameters must by struture of type Parameters');
    throw(ME);
end;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting the function variables
waterDepth          = parameters.environemnt.waterDepth;
waterDensity        = parameters.environemnt.waterDensity;
g                   = parameters.environemnt.g;
k                   = [];
freqBinWidth        = [];

if nargin > 3
    indx = 4;
    while indx <= nargin
        if varargin{indx-3}== 'D'
            % deep water specified, overwriting the water depth
            waterDepth = inf;
            parameters.environemnt.waterDepth = waterDepth;
            indx = indx +1;
        elseif strcmp(varargin{indx-3},'freqBinWidth')
            if all([isnumeric(varargin{indx-2}), length(varargin{indx-2}) > 1])
                % the vector for k has been passed
                freqBinWidth = varargin{indx-2};
                indx = indx +2;
                % checking that the freqBinWidth is a vector
                if any([isscalar(freqBinWidth),~isnumeric(freqBinWidth)]);
                    ME = MException('MATLAB:OmniDirEnergyFlux','freqBinWidth must be a vector of numbers');
                    throw(ME);
                end;
                
                % checking to see if the Spectrum, Frequency, and freqBinWidth are the same length
                if (length(spectrum) ~= length(freqBinWidth))
                    ME = MException('MATLAB:OmniDirEnergyFlux','frequency, spectrum and freqBinWidth must be the same length');
                    throw(ME);
                end;  
            else
                ME = MException('MATLAB:OmniDirEnergyFlux','freqBinWidth must be a vector of numbers');
                throw(ME);
            end;
        elseif strcmp(varargin{indx-3},'k')
            if all([isnumeric(varargin{indx-2}), length(varargin{indx-2}) > 1])
                % the vector for k has been passed
                k = varargin{indx-2};
                indx = indx +2;
                % checking that the Spectrum and Fequency are vectors
                if any([isscalar(k), ~isnumeric(k)]);
                    ME = MException('MATLAB:OmniDirEnergyFlux','k must be a vector of numbers');
                    throw(ME);
                end;
                
                % checking to see if the Spectrum and Frequency are the same length
                if (length(spectrum) ~= length(k))
                    ME = MException('MATLAB:OmniDirEnergyFlux','frequency, spectrum, and k must be the same length');
                    throw(ME);
                end;
                
            else
                ME = MException('MATLAB:OmniDirEnergyFlux','k must be a vector of numbers');
                throw(ME);
            end;
        end;
    end;
end;

% if freqBinWidth is not input, assume even frequency spacing
if isempty(freqBinWidth)
    % need to check for evenly spaced frequency vector %%******
    disp('freqBinWidth not specified');
    freqBinWidth = ones(size(frequency))*mean(diff(frequency));
end;



% Calculating the omnidirectional wave energy flux.
if ~isinf(waterDepth)
    % Water depth is specified, so calculate the group velocity based on
    % the specified water depth
    
    % check to see if waterDepth is a valid depth
    if any([~isreal(waterDepth), waterDepth < 0, ~isnumeric(waterDepth)])
        ME = MException('MATLAB:OmniDirEnergyFlux','Invalid water depth');
        throw(ME);
    end
    
    % exclude the first value if its zero
    if  frequency(1) ~= 0
        firstIdx = 1;
    else
        firstIdx = 2;
    end;
    
    if isempty(k)
        % Calculate wave number
        disp('k not specified');
        k = KfromF(frequency, parameters);
    end;
    
    % calculating the group velocity, based on IEC TS 62600-100
    Cp = sqrt(g*tanh(waterDepth*k(firstIdx:end))./k(firstIdx:end));
    Cg = Cp/2.*(1+(2*waterDepth*k(firstIdx:end))./sinh(2*waterDepth*k(firstIdx:end)));
    
    % calculating the wave energy flux
    J  = waterDensity*g*sum(freqBinWidth(firstIdx:end).*spectrum(firstIdx:end).*Cg);
    
else
    % Deep water calculation, if water depth is not specified, deep water
    % is the default
    
    
    Te = frequencyMoment(frequency, spectrum, freqBinWidth,-1)/frequencyMoment(frequency, spectrum, freqBinWidth,0);
    Hm0 = 4*sqrt(frequencyMoment(frequency, spectrum, freqBinWidth, 0));
    J = waterDensity*g*g/64/pi*Hm0*Hm0*Te;
end;


