function mechPower = CalcMechPower(kinPower, dynPower,powerTime,sampleRate,varargin)

% mechPower = CalcMechPower(kinPower, dynPower,powerTime,sampleRate,varargin)
%
% Calculates the wave energy power of a time series and populates the
% waveSpectra MHKiT structure.
%
% Input:
%   kinPower                time series of the kinematic side of power,
%                           either velocity (m/s), angular velocity
%                           (rads/s) or volumetric flow rate (m^3/2). 
%                           kinPower can be vector or an m x n matrix where
%                           m is the number of measurements of kinPower and
%                           n is the number of samples.
%   dynPower                time series of the dynamic side of power,
%                           either force (N), Torque (N/m) or Pressure
%                           (N/m^2) dynPower can be vector or an m x n
%                           matrix where m is the number of measurements
%                           of kinPower and n is the number of samples.
%   powerTime               powerwave elevation time series (m)
%   sampleRate              sample rate of the power time series
%                           (Hz)
%   Is
%   parameters (optional)   MHKiT structure (optional), these values will
%                           specify the water density, water depth, and
%                           gravity parameters, otherwise, default values
%                           are used
%
% Output:
%   mechPower               MHKiT structure that contains all of the data
%                           and metadata for the mechanical power
%                           calculations
%
% Dependencies
%  initMechPower
%
% Usage
%   CalcWaveSpectrum(waveSpectra,NFFT,sampleRate)
%   Calculates the spectrum and wave statistics using the deep water
%   assumption and using default gravity and water density. The statistics
%   are calculated over all frequencies
%

%
% Version 1, 11/25/2018 Rick Driscoll, NREL and Bradley Ling, Northwest Energy Innovations

% Initiating a mechPower MHKiT structure
mechPower = initMechPower();

% check to see if the correct number of arguments are being passed
if nargin < 3
    error('CalcMechPower: Incorrect number of input arguments, requires at least 3 arguments');
end;

if nargin > 6
    error('CalcMechPower: Incorrect number of input arguments, too many agruments, requires 6 at most');
end;

%check to see if the first input argumeent is a time series
if ~isvector(kinPower) | ~ismatrix(kinPower)
    error('CalcMechPower: kinPower must be a vector or matrix');
end;

%check to see if the second input argument is a time series
if ~isvector(dynPower) | ~ismatrix(dynPower)
    error('CalcMechPower: dynPower must be a vector or matrix');
end;

%check to see if the second input argument is a time series
if ~isvector(powerTime) | ~ismatrix(powerTime)
    error('CalcMechPower: powerTime must be a vector or matrix');
end;

% check to see if the dynmic side and kinematic side are the same size
if numel(kinPower) ~= numel(dynPower)
    error('CalcMechPower: kinPower and dynPower must be the same size');
end;

% check to see if the dynmic side, kinematic side, and time are the same
% length
if ~(length(kinPower) & length(dynPower) & length(powerTime))
    error('CalcMechPower: kinPower, dynPower, and powerTime must be the same length');
end;











