function k = KfromF(frequency,parameters)
%
% k = KfromF(waveSpectra)
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
%
% Version 1, 11/25/2018 Rick Driscoll, NREL and Bradley Ling, Northwest Energy Innovations

if isstruct(parameters)
    % checking for the parameters structure to be passed
    if ~strcmp(parameters.structType,'Parameters')
        ME = MException('MATLAB:CalcKfromF','Invalid input, parameters must by struture of type Parameters');
        throw(ME);
    end;
else
    ME = MException('MATLAB:CalcKfromF','Invalid input, parameters must by struture of type Parameters');
    throw(ME);
end;

%check to see if the frequency is a vector
if any(~isnumeric(frequency))
    ME = MException('MATLAB:CalcKfromF','frequency must be a number');
    throw(ME);
end;

% Calculate angular frequency from the frequency, Hz to rads/s
w = 2.*pi.*frequency;

% use KfromW to calcualte k
k = KfromW(w,parameters);











