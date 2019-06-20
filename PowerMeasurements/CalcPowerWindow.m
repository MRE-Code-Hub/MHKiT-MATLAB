function powerdata=CalcPowerWindow(voltage,current,time,samplerate,dateTime,parameters,varargin)

% Breaks down the input time series into averaging windows and 
% Populates the InitPowerData structure 
%
% Input:
%    voltage                 Time series of measured volatege (V) of form 
%                     [time , Nchannels]
%    current                 Time series of the measured current (A) of form
%                     [time , Nchanels]
%    time                    measurement time vector (s)
%    samplerate              sample rate of time series in Hz
%    avgwindow               the length of the window to average over (s)
%    dateTime                 a vector containing the time series of the
%                            date and time represented in days since January 1, 0000. 
%                            Use Matlab function DateNumber() to create this
%                            input
%   parameters              MHKiT structure of various parameters
%
%    timeRange (optional)   Two element vector [T1, T2] (s) that bound the
%                           calculations, where T1 is the time where the
%                           calculations will start and T2 is the time
%                           where the calculations will stop. If empty,
%                           then the calculations are performed over
%                           the entire time series. This variable should
%                           also be made from the DateNumber function. 
% Output: 
%    powerdata          Power statistics structure for each averaging window
%
% Dependancies: 
%        initPowerData
%        CalcPowerDC
%
% Usage: 
%    CalcPowerWindow(Voltage,current,time,samplerate,dateTime,parameters)
%    Breaks down the input time series into averaging windows and
%    fills the powerdata structure
%
%    CalcPowerWindow(Voltage,current,time,samplerate,dateTime,parameters,timeRange)
%    Breaks down the input time series into averaging windows and
%    fills the powerdata structure. timeRange will dictate the subset of
%    the time series which is used. 

%
% Version 1, 05/17/2019 Rebecca Pauly, NREL

powerdata = initPowerData();

% check to see if correct number of arguments were passed
if nargin < 6 
    ME = MException('MATLAB:CalcPowerWindow','Incorrect number of input arguments, requires at lest 6 arguments, %d arguments passed',nargin);
    throw(ME);
end

if nargin > 7 
    ME = MException('MATLAB:CalcPowerWindow',['Incorrect number of input arguments, too many arguments, requires at most 7, %d arguments passed',nargin]);
    throw(ME);   
end

if isstruct(parameters)
    % checking for the parameters structure to be passed
    if ~strcmp(parameters.structType,'Parameters')
        ME = MException('MATLAB:CalcPowerWindow','Invalid input, parameters must by struture of type Parameters');
        throw(ME);
    end;
else
    ME = MException('MATLAB:CalcPowerWindow','Invalid input, parameters must by struture of type Parameters');
    throw(ME);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting the function variables
sampleRate          = parameters.data.sampleRate;
spectTimeLngth      = parameters.spectrum.spectTimeLngth;
spectraTimeSpacing  = parameters.spectrum.spectraTimeSpacing;
freqIdxSt           = [];
freqIdxEd           = [];

% default is one spectrum calculated from the entire time series, this is
% changed later if spectraTimeSpacing and/or spectTimeLngth are set
startIdx            = 1;
endIdx              = length(voltage);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% check that first input argument is a numeric matrix
if any([~ismatrix(voltage),~isnumeric(voltage), length(voltage)==1])
    ME=MException('MATLAB:CalcPowerWindow','voltage must be a numeric matrix with length > 1');
    throw(ME);
end

%check that the 2nd input argument is a numeric matrix
if any([~ismatrix(current),~isnumeric(current),length(current)==1])
    ME=MException('MATLAB:CalcPowerWindow','Current must be a numeric matrix with lenght >1');
    throw(ME);
end

%check that the 3rd input argument is a numeric vector
if any([~isvector(time),~isnumeric(time),length(time)==1])
    ME=MException('MATLAB:CalcPowerWindow','Time must be a numeric vector with lenght >1');
    throw(ME);
end

current_size = size(current);
voltage_size = size(voltage);
time_size = length(time);
time_current_compare = current_size == time_size;
time_voltage_compare = voltage_size == time_size;

% check that the current and voltage arrays are of the same size/dimensions
if ~isequal(current_size,voltage_size)
    ME=MException('MATLAB:CalcPowerWindow','Current and voltage arrays must be same size');
    throw(ME);
end

% check that time and current/voltage have a dimension of the same length

if any([time_current_compare(1) ~= 1, time_voltage_compare(1) ~= 1])
    ME=MException('MATLAB:CalcPowerWindow','Time input is not same length as current or voltage dimension');
    throw(ME);
end

% Determining if the start and end times have be set

if nargin == 7
    timeRange = varargin{1};
                
                % finding the indices for the specrtal calculations
    startIdx = find(dateTime >= timeRange(1),1);
    if any([isempty(startIdx), (timeRange(1)-dateTime(1))*24*3600 < -1/sampleRate])
        ME = MException('MATLAB:CalcPowerWindow','start time is not within the range of dateTime');
        throw(ME);
    end;
    endIdx   = find(dateTime >= timeRange(2),1);
    if isempty(endIdx)
       ME = MException('MATLAB:CalcPowerWindow','end time is not within the range of dateTime');
       throw(ME);
    end;
   
else
    startind=1; 
    endind=time_size;
end

% determining the indexing into the time series for the spectra
% calcualtions

if ~isempty(spectraTimeSpacing)
    % the total span of time between the starting index of each time
    % series segment is specified, therefore, the starting location of
    % each time series segment is specified
    NumDataPointsSpecSpac   = spectraTimeSpacing*sampleRate;
    startIdx = startIdx:NumDataPointsSpecSpac:(endIdx-NumDataPointsSpecSpac+1);
    if ~isempty(spectTimeLngth)
        % spectTimeLngth is specified, therefore mapping the endIdx to the
        % specified length of each time series used to calculate each
        % spectrum
        NumDataPointsPerSpec    = spectTimeLngth*sampleRate;
        endIdx = startIdx+NumDataPointsPerSpec-1;
    else
        % spectTimeLngth not specified, therefor assume the whole
        % NumDataPointsSpecSpac window is used to calculate each spectrum
        endIdx = startIdx+NumDataPointsSpecSpac-1;
    end;
elseif ~isempty(spectTimeLngth)
    % Since the time span between the starting index of each time segment
    % is NOT specified, assume the time span between segments is equal to
    % the specified length of each time series used to calcualte each
    % spectrum
    NumDataPointsPerSpec    = spectTimeLngth*sampleRate;
    startIdx = startIdx:NumDataPointsPerSpec:(endIdx-NumDataPointsPerSpec+1);
    endIdx   = startIdx+NumDataPointsPerSpec-1;
end;


% current=current(startind:endind,:);
% voltage=voltage(startind:endind,:);
% day_time=dateTime(startind:endind,:);
% newtime=time(startind:endind,:);
% datatime_len=time(endind)-time(startind);
% window_len=samplerate*avgwindow;
% n_windows=length(newtime)/window_len;
% starti=1;
% ind2=(1:n_windows)*window_len;
% ind1=ind2(1:end-1)+1;
% ind1=[1,ind1];
%powerdata.time=[dateTime(ind1),dateTime(ind2)];


for specIndx = 1:length(startIdx)
    powerdata.dateTime= [powerdata.dateTime;dateTime(startIdx(specIndx))];
    powerstats=CalcPowerDC(voltage(startIdx(specIndx):endIdx(specIndx),:),current(startIdx(specIndx):endIdx(specIndx),:),dateTime(startIdx(specIndx):endIdx(specIndx),:),samplerate);
    powerdata.current.min=[powerdata.current.min;powerstats.stats.chanmincurrent];
    powerdata.current.max=[powerdata.current.max;powerstats.stats.chanmaxcurrent];
    powerdata.current.avg=[powerdata.current.avg;powerstats.stats.chanavgcurrent];
    powerdata.current.std=[powerdata.current.std;powerstats.stats.chanstdcurrent];
    powerdata.voltage.min=[powerdata.voltage.min;powerstats.stats.chanminvoltage];
    powerdata.voltage.max=[powerdata.voltage.max;powerstats.stats.chanmaxvoltage];
    powerdata.voltage.avg=[powerdata.voltage.avg;powerstats.stats.chanavgvoltage];
    powerdata.voltage.std=[powerdata.voltage.std;powerstats.stats.chanstdvoltage];
    powerdata.power.min=[powerdata.power.min;powerstats.stats.chanminpower];
    powerdata.power.max=[powerdata.power.max;powerstats.stats.chanmaxpower];
    powerdata.power.avg=[powerdata.power.avg;powerstats.stats.chanavgpower];
    powerdata.power.std=[powerdata.power.std;powerstats.stats.chanstdpower];
    powerdata.power.grossmin=[powerdata.power.grossmin;powerstats.stats.grossminpower];
    powerdata.power.grossmax=[powerdata.power.grossmax;powerstats.stats.grossmaxpower];
    powerdata.power.grossavg=[powerdata.power.grossavg;powerstats.stats.grossavgpower];
    powerdata.power.grossstd=[powerdata.power.grossstd;powerstats.stats.grossstdpower];
end


