function powerdata = initPowerData() 
% 
% powerdata = initPowerData()
%
% Initilizes a single instance of power data structure 
% n = number of averaging windows in the time series
% m = number of channels in the dataset
% 
% Input: 
%     none
%
% Output:
%     powerdata
%
% Dependancies: 
%    none
%
% Useage: 
%    powerdata = initPowerData()
%
% Version 1.01, 05/21/2019, Rebecca Pauly,NREL

powerdata.structType                 = 'powerdata';
powerdata.dateTime                   = []; % [n array] Window start time 
powerdata.nchan                      = []; % number of channels of phases
powerdata.current.avg                = []; % [nxm array] channel current averages
powerdata.current.min                = []; % [nxm array] channel current min
powerdata.current.max                = []; % [nxm array] channel current max
powerdata.current.std                = []; % [nxm array] channel current std
powerdata.voltage.avg                = []; % [nxm array] channel voltage avg
powerdata.voltage.min                = []; % [nxm array] channel voltage min
powerdata.voltage.std                = []; % [nxm array] channel voltage std
powerdata.voltage.max                = []; % [nxm array] channel voltage max
powerdata.power.avg                  = []; % [nxm array] channel power avg
powerdata.power.min                  = []; % [nxm array] channel power min
powerdata.power.max                  = []; % [nxm array] channel power max
powerdata.power.std                  = []; % [nxm array] channel power std
powerdata.power.grossavg             = []; % [nx1 array] gross power avg
powerdata.power.grossmin             = []; % [nx1 array] gross power min
powerdata.power.grossmax             = []; % [nx1 array] gross power max
powerdata.power.grossstd             = []; % [nx1 array] gross power std
powerdata.props.latitude             = [];
powerdata.props.longitude            = [];
powerdata.props.numSamples           = [];
powerdata.props.sampleRate           = [];
powerdata.props.timeseriesduration   = [];
powerdata.props.avglength            = [];
end