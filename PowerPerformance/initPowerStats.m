function powerstats = initpowerstats() 
% 
% powerstats = initpowerstats()
%
% Initilizes a single instance of power data structure 
% 
% Input: 
%     none
%
% Output:
%     powerstats
%
% Dependancies: 
%    none
%
% Useage: 
%    powerstats = initpowerstats()
%
% Version 1.01, 05/21/2019, Rebecca Pauly,NREL

powerstats.structType                 = 'powerstats';
powerstats.datetime                   = [];
powerstats.nchan                      = []; % number of channels of phases
powerstats.power                      = [];
powerstats.grosspower                 = [];
powerstats.stats.chanavgcurrent       = [];
powerstats.stats.chanmincurrent       = [];
powerstats.stats.chanmaxcurrent       = [];
powerstats.stats.chanstdcurrent       = [];
powerstats.stats.chanavgvoltage       = [];
powerstats.stats.chanminvoltage       = [];
powerstats.stats.chanmaxvoltage       = [];
powerstats.stats.chanstdvoltage       = [];
powerstats.stats.chanavgpower         = []; % channel or phase average [n,1]
powerstats.stats.chanminpower         = [];
powerstats.stats.chanmaxpower         = [];
powerstats.stats.chanstdpower         = [];
powerstats.stats.grossavgpower        = [];
powerstats.stats.grossmaxpower        = [];
powerstats.stats.grossminpower        = [];
powerstats.stats.grossstdpower        = [];
powerstats.props.latitude             = [];
powerstats.props.longitude            = [];
powerstats.props.numSamples           = [];
powerstats.props.sampleRate           = [];
powerstats.props.timeseriesduration   = [];
end