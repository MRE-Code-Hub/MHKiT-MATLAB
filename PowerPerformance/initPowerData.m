function powerData = initPowerData()
%
% powerData = initPowerData();
%
%
% Initalizes a single instance of a powerData structure
%
% Input:
%   none;
%
% Output:
%   powerData                     MRETRes structure
%
% Dependencies
%   none
%
% Usage
%   powerData = initPowerData();
%
% Version 1.01, 11/25/2018Rick Driscoll, NREL


powerData.dateTime         = [];
waveSpectra.numFrequencies   = [];
waveSpectra.bandwidth        = [];
waveSpectra.props.latitude   = [];
waveSpectra.props.longitude  = [];
waveSpectra.props.waterDepth = [];
waveSpectra.props.numSamples = [];
waveSpectra.props.sampleRate = [];
waveSpectra.Spectrum         = [];
waveSpectra.dirSpec.a1       = [];
waveSpectra.dirSpec.a2       = [];
waveSpectra.dirSpec.b1       = [];
waveSpectra.dirSpec.b2       = [];
waveSpectra.dirSpec.qaFlag   = [];
waveSpectra.stats.Hs         = [];
waveSpectra.stats.Hmo        = [];
waveSpectra.stats.Tp         = [];
waveSpectra.stats.Dp         = [];
waveSpectra.stats.Ta         = [];
waveSpectra.stats.Te         = [];
waveSpectra.qaFlag           = [];