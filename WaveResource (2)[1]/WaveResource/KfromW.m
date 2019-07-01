function k = KfromW(w,guessK,parameters)
%
% k = KfromW(w,guessK,waterDepth,parameters)
%
% calculates the wave number from the angular frequency and an inital 
% guess at the wave number.
%
% Input:
%   w                       Angular frequency of a component of the wave  
%                           energy spectrum(rads/s)
%   guessK                  Inital guess at the wave number (1/m)
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
%   calculates the wave number from the angular frequency, an inital 
%   guess at the wave number, and the water depth. Without the parameters
%   provided, default values for gravity water density are used.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% I belive much of this code was borrowed from an open-source site. I
%   need to spend some time finding it before we release the code
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Version 1, 11/25/2018 Rick Driscoll, NREL and Bradley Ling, Northwest Energy Innovations

% parsing out and assigning the variables from the input arguments
if nargin == 3
        g = parameters.g;                   % gravitational constant
        rho = parameters.waterDensity;      % density of water
        gamma = parameters.gamma;
        h = parameters.waterDepth;
        if isinf(h)
            error('KfromW: water depth cannot be deep water (inf)');
        end;
else
        error('KfromW: Invalid input arguments');
end;

    % check to see if h is a valid depth
    if any([~isreal(h), h < 0])
        error('KfromW: Invalid water depth in wave spectra structure');
    end

% calculate K
warning ('off','all');
for i=1:numel(w)
    k = fzero(@(kk) w - sqrt(tanh(kk*h) * (g*abs(kk) + gamma*abs(kk)^3/rho)), guessK,optimset('display','off'));
end