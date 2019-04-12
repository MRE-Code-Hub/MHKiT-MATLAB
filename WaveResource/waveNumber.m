function k = waveNumber(waveSpectra)
%
% k = waveNumber(waveSpectra)
%
% Calculates the wave number for each component of the spectrum.
%
% Input:
%   waveSpectra             MHKiT structure that contains all of the data
%                           and metadata for the wave spectra calculatione
%
% Output:
%   k                             vector of wave number for each component
%                                 in the wave energy spectrum
% Dependencies
%   KfromW
%
% Usage
%   waveNumber(waveSpectra);
%   Calculates the vector of wave numbers for each wave component using the
%   default values for  gravity and water density;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% I belive much of this code was borrowed from an open-source site. I
%   need to spend some time finding it before we release the code
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Version 1, 11/25/2018 Rick Driscoll, NREL and Bradley Ling, Northwest Energy Innovations


if nargin > 1
    error('waveNumber: Incorrect number of input arguments, too many agruments, requires 1 at most');
end;

% checking for the waveSpectra structure to be passed
if isstruct(waveSpectra)
    if waveSpectra.structType   ~= 'waveSpectra'
        error('waveNumber: Invalid Structure input, first argument must by type waveSpectra');
    end;
else
    error('waveNumber: Invalid Structure input, first argument must by type waveSpectra');
end;
    
if isempty(waveSpectra.environment.waterDensity)
    error('waveNumber: Density not specified, using default');
    waveSpectra.environment.waterDensity    = 1025;
end;
if isempty(waveSpectra.environment.g)
    error('waveNumber: Gravitational accleration not specified, using default');
    waveSpectra.environment.g               = 9.81;
end;

if isempty(waveSpectra.environment.waterDepth)
    error('waveNumber: Water depth not specified, using deep water');
    waveSpectra.environment.waterDepth      = inf;
end;

% Initalizing commly accessed variables
h   = waveSpectra.environment.waterDepth;
rho = waveSpectra.environment.waterDensity;
g   = waveSpectra.environment.g;

% assigning the water depth then checking to make sure the depth is valid
if any([~isreal(h), h < 0])
    error('waveNumber: Invalid water depth in wave spectra structure');
end

% Calculate angular frequency from the frequency, Hz to rads/s
w = 2.*pi.*waveSpectra.frequency;

%Make initial guess with Guo (2002)
if w(1) ~= 0
    xi = w(1)./sqrt(g./h); %note: =h*wa/sqrt(h*g/h)
    stIdx = 1;
else
    xi = w(2)./sqrt(g./h); %note: =h*wa/sqrt(h*g/h)
    stIdx = 2;
end;
yi = xi.*xi/(1.0-exp(-xi.^2.4908)).^0.4015;
guessK = yi/h; %Initial guess without current-wave interaction

%forward declaring the k vector
k = nan(size(w));
for ii = stIdx:numel(w)
       k(ii) = KfromW(w(ii),guessK,waveSpectra.environment);
    if isnan(k(ii))
        xi = w(ii)./sqrt(g./h); %note: =h*wa/sqrt(h*g/h)
        yi = xi.*xi/(1.0-exp(-xi.^2.4908)).^0.4015;
        guessK = yi/h; %Initial guess without current-wave interaction
        k(ii) = KfromW(w(ii),guessK,waveSpectra.environment);
    end
    guessK = k(ii);
end




