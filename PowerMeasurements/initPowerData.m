function powerdata = initPowerData() 
% 
% powerdata = initPowerData()
%
% Initilizes a single instance of power data structure 
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
powerdata.datetime                   = [];
powerdata.nchan                      = []; % number of channels of phases
powerdata.voltage                    = []; % will be optionally filled with velocity, w, or pressure for mechanical power?? 
powerdata.current                    = []; % optionally filled with force, torque, or Q? 
powerdata.power                      = [];
powerdata.grosspower                 = [];
powerdata.stats.chanavgcurrent       = [];
powerdata.stats.chanmincurrent       = [];
powerdata.stats.chanmaxcurrent       = [];
powerdata.stats.chanstdcurrent       = [];
powerdata.stats.chanavgvoltage       = [];
powerdata.stats.chanminvoltage       = [];
powerdata.stats.chanmaxvoltage       = [];
powerdata.stats.chanstdvoltage       = [];
powerdata.stats.chanavgpower         = []; % channel or phase average [n,1]
powerdata.stats.chanminpower         = [];
powerdata.stats.chanmaxpower         = [];
powerdata.stats.chanstdpower         = [];
powerdata.stats.grossavgpower        = [];
powerdata.stats.grossmaxpower        = [];
powerdata.stats.grossminpower        = [];
powerdata.stats.grossstdpower        = [];
powerdata.props.latitude             = [];
powerdata.props.longitude            = [];
powerdata.props.numSamples           = [];
powerdata.props.sampleRate           = [];
powerdata.props.timeseriesduration   = [];
end