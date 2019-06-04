function powerdata=CalcPowerWindow(voltage,current,time,samplerate,day_time,avgwindow,varargin)

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
%    daytime                 a vector containing the time series of the
%                            date and time represented in days since January 1, 0000. 
%                            Use Matlab function datetime() to create this
%                            input
%
%    starttime (optional)    time in for beginning of analysis (s)
%    endtime   (optional)    time in for end of analysis (s)
%    Note: if starttime is set, then endtime must also be set, and
%          vice-versa
%
% Output: 
%    powerdata          Time series of the new power (W)
%
% Dependancies: 
%        initPowerData
%        CalcPowerDC
%
% Usage: 
%    CalcPowerWindow(Voltage,current,time,samplerate,day_time,avgwindow,varagin)
%    Breaks down the input time series into averaging windows and
%    fills the powerdata structure
%
% Version 1, 05/17/2019 Rebecca Pauly, NREL

powerdata = initPowerData();

% check to see if correct number of arguments were passed
if nargin < 6 
    ME = MException('MATLAB:CalcPowerDC','Incorrect number of input arguments, requires at lest 6 arguments, %d arguments passed',nargin);
    throw(ME);
end

if nargin > 8 
    ME = MException('MATLAB:CalcPowerDC',['Incorrect number of input arguments, too many arguments, requires at most 8, %d arguments passed',nargin]);
    throw(ME);   
end

% check that first input argument is a numeric matrix
if any([~ismatrix(voltage),~isnumeric(voltage), length(voltage)==1])
    ME=MException('MATLAB:CalcPowerDC','voltage must be a numeric matrix with length > 1');
    throw(ME);
end

%check that the 2nd input argument is a numeric matrix
if any([~ismatrix(current),~isnumeric(current),length(current)==1])
    ME=MException('MATLAB:CalcPowerDC','Current must be a numeric matrix with lenght >1');
    throw(ME);
end

%check that the 3rd input argument is a numeric vector
if any([~isvector(time),~isnumeric(time),length(time)==1])
    ME=MException('MATLAB:CalcPowerDC','Time must be a numeric vector with lenght >1');
    throw(ME);
end

%check that avgwindow is a numeric scalar
if any([length(avgwindow)~=1, ~isnumeric(avgwindow)])
    ME=MException('MATLAB:CalcPowerDC','avgwindow must be a numeric scalar');
    throw(ME);
end

current_size = size(current);
voltage_size = size(voltage);
time_size = length(time);
time_current_compare = current_size == time_size;
time_voltage_compare = voltage_size == time_size;

% check that the current and voltage arrays are of the same size/dimensions
if ~isequal(current_size,voltage_size)
    ME=MException('MATLAB:CalcPowerDC','Current and voltage arrays must be same size');
    throw(ME);
end

% check that time and current/voltage have a dimension of the same length

if any([time_current_compare(1) ~= 1, time_voltage_compare(1) ~= 1])
    ME=MException('MATLAB:CalcPowerDC','Time input is not same length as current or voltage dimension');
    throw(ME);
end

% Determining if the start and end times have be set
if nargin == 7
    ME=MException('MATLAB:CalcPowerDC','Invalid numer of arguments, if starttime is set, so does endtime');
    throw(ME);
end

if nargin == 8
    starttime=varargin{1};
    endtime=varargin{2};
    if any([length(starttime)~=1,~isnumeric(starttime)])
        ME=MException('MATLAB:CalcPowerDC','Starttime needs to be a scalar of numeric type');
        throw(ME);
    end
    if any([length(endtime)~=1,~isnumeric(endtime)])
        ME=MException('MATLAB:CalcPowerDC','Endtime needs to be a numeric type scalar');
        throw(ME);
    end
    min_time_start_diff=min(abs(time-starttime));
    min_time_end_diff=min(abs(time-endtime));
    startind=find(abs(time-starttime)==min_time_start_diff);
    endind=find(abs(time-endtime)==min_time_end_diff);
else
    startind=1; 
    endind=time_size;
end

current=current(startind:endind,:);
voltage=voltage(startind:endind,:);
day_time=day_time(startind:endind,:);
newtime=time(startind:endind,:);
datatime_len=time(endind)-time(startind);
window_len=samplerate*avgwindow;
n_windows=length(newtime)/window_len;
starti=1;
ind2=(1:n_windows)*window_len;
ind1=ind2(1:end-1)+1;
ind1=[1,ind1];
powerdata.time=[day_time(ind1),day_time(ind2)];


for i=1:n_windows
    powerstats=CalcPowerDC(voltage(ind1(i):ind2(i),:),current(ind1(i):ind2(i),:),newtime(ind1(i):ind2(i),:),samplerate);
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
powerdata
powerdata.current
powerdata.voltage
powerdata.power

