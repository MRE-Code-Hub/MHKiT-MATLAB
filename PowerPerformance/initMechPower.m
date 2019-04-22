function mechPower = initMechPower();
%
% mechPower = initMechPower()
%
% Initalizes a single instance of a MechPower structure
%
% Input:
%   none;
%
% Output:
%   mechPower                     MRETRes structure
%
% Dependencies
%   none
%
% Usage
%   mechPower = initMechPower())
%
% Version 1.01, 11/25/2018Rick Driscoll, NREL

mechPower.structType                  = 'mechPower';
mechPower.dateTime                    = [];
mechPower.frequency                   = [];
mechPower.rawDynSide                  = [];
mechPower.rawDinSide                  = [];
mechPower.props.sampleRate            = [];
mechPower.props.TimeSeriesDuration    = [];
