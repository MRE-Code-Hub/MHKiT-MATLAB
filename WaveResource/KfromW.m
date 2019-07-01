function k = KfromW(w,parameters)
%
% k = KfromW(w,guessK,waterDepth,parameters)
%
% calculates the wave number from the angular frequency and an inital
% guess at the wave number.
%
% Input:
%   w                       Angular frequency of a component of the wave
%                           energy spectrum(rads/s)
%   parameters              MHKiT structure (optional), these values will
%                           specify the water density, water depth, and
%                           gravity parameters, otherwise, default values
%                           are used
%
% Output:
%   k                             Wave number (1/m) for a component of the
%                                 Wave energy spectrum
% Dependencies
%   none
%
% Usage
%   KfromW(w,guessK,parameters);
%   calculates the wave numbers from the angular frequency, an inital
%   guess at the wave number, and the water depth. Without the parameters
%   provided, default values for gravity water density are used.
%
%
%
% Version 1, 11/25/2018 Rick Driscoll, NREL and Bradley Ling, Northwest Energy Innovations

% parsing out and assigning the variables from the input arguments

if isstruct(parameters)
    % checking for the parameters structure to be passed
    if ~strcmp(parameters.structType,'Parameters')
        ME = MException('MATLAB:CalcKfromW','Invalid input, parameters must by struture of type Parameters');
        throw(ME);
    end;
else
    ME = MException('MATLAB:CalcKfromW','Invalid input, parameters must by struture of type Parameters');
    throw(ME);
end;

%check to see if the frequency is a vector
if any(~isnumeric(w))
    ME = MException('MATLAB:CalcKfromW','angular frequency must be a number');
    throw(ME);
end;



waterDepth          = parameters.environemnt.waterDepth;
waterDensity        = parameters.environemnt.waterDensity;
g                   = parameters.environemnt.g;
gamma               = parameters.environemnt.gamma;

% assigning the water depth then checking to make sure the depth is valid
if isinf(waterDepth)
        ME = MException('MATLAB:KfromW','water depth cannot be deep water (inf)');
        throw(ME);
    end;
if any([~isreal(waterDepth), waterDepth < 0])
    ME = MException('MATLAB:KfromW','Invalid water depth');
    throw(ME);
end

% Make initial guess with Guo (2002)
% Check to see if the first value of the angular frequency is zero, if so,
% skip to the second value.
if w(1) ~= 0
    xi = w(1)./sqrt(g./waterDepth); %note: =h*wa/sqrt(h*g/h)
    stIdx = 1;
else
    xi = w(2)./sqrt(g./waterDepth); %note: =h*wa/sqrt(h*g/h)
    stIdx = 2;
end;
yi = xi.*xi/(1.0-exp(-xi.^2.4908)).^0.4015;
guessK = yi/waterDepth; %Initial guess without current-wave interaction

%forward declaring the k vector
k = nan(size(w));
warning ('off','all');
for ii = stIdx:numel(w)
       k(ii) = fzero(@(k) w(ii)-sqrt(tanh(k*waterDepth)*(g*abs(k) + gamma*abs(k)^3/waterDensity)), guessK,optimset('display','off'));
    if isnan(k(ii))
        xi = w(ii)./sqrt(g./waterDepth); %note: =h*wa/sqrt(h*g/h)
        yi = xi.*xi/(1.0-exp(-xi.^2.4908)).^0.4015;
        guessK = yi/waterDepth; %Initial guess without current-wave interaction
        k(ii) = fzero(@(k) w(ii)-sqrt(tanh(k*waterDepth)*(g*abs(k) + gamma*abs(k)^3/waterDensity)), guessK,optimset('display','off'));
    end
    guessK = k(ii);
end

%[w;(g*k.*tanh(k*waterDepth)).^0.5]

