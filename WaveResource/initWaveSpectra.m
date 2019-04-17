
function waveSpectra = initWaveSpectra();
%
% waveSpectra = initWaveSpectra()
%
% Initalizes a single instance of a waveSpectra structure
%
% Input:
%   none;
%
% Output:
%   waveSpectra                     MRETRes structure
%
% Dependencies
%   none
%
% Usage
%   waveSpectra = initWaveSpectra()
%
% Version 1.01, 11/25/2018Rick Driscoll, NREL

waveSpectra.structType                  = 'waveSpectra';
waveSpectra.dateTime                    = [];
waveSpectra.frequency                   = [];
waveSpectra.Spectrum                    = [];
waveSpectra.Upper95Conf                 = [];
waveSpectra.Lower95Conf                 = [];
waveSpectra.bandwidth                   = [];
waveSpectra.props.latitude              = [];
waveSpectra.props.longitude             = [];
waveSpectra.props.numSamples            = [];
waveSpectra.props.sampleRate            = [];
waveSpectra.props.TimeSeriesDuration    = [];
waveSpectra.props.freqRange             = [];
waveSpectra.props.confInterval          = [];
waveSpectra.environment.waterDepth      = inf;
waveSpectra.environment.waterDensity    = 1025;
waveSpectra.environment.gamma           = 1;
waveSpectra.environment.g               = 9.81;   
waveSpectra.dirSpec.a1                  = [];
waveSpectra.dirSpec.a2                  = [];
waveSpectra.dirSpec.b1                  = [];
waveSpectra.dirSpec.b2                  = [];
waveSpectra.dirSpec.qaFlag              = [];
waveSpectra.stats.J                     = [];
waveSpectra.stats.Hs                    = [];
waveSpectra.stats.Hm0                   = [];
waveSpectra.stats.Tp                    = [];
waveSpectra.stats.T0                    = [];
waveSpectra.stats.Dp                    = [];
waveSpectra.stats.Tm                    = [];
waveSpectra.stats.Te                    = [];
waveSpectra.stats.e                     = [];
waveSpectra.stats.v                     = [];
waveSpectra.qaFlag                      = [];
