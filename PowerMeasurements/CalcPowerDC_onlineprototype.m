function powerdata=CalcPowerDC(voltage,current,time,samplerate,daytime,avgwindow,varagin)

% Calcuates the Time series of net power from voltage and current
% and populates the InitPowerData structure 
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
%    power          Time series of the new power (W)
%
% Dependancies: 
%        initPowerData
%
% Usage: 
%    CalcPowerDC(Voltage,current,time)
%    Calculates the time series of net power for DC
%    current 
%
% Version 1, 05/17/2019 Rebecca Pauly, NREL

powerdata = initPowerData();

% check to see if correct number of arguments were passed
if nargin < 6 
    ME = MException('MATLAB:CalcPowerDC','Incorrect number of input arguments, reguires at lest 5 arguments, %d arguments passed',nargin);
    throw(ME);
end

if nargin > 8 
    ME = MException('MATLAB:CalcPowerDC',['Incorrect numner of input arguments, too many arguments, requires at most 7, %d arguments passed',nargin]);
    throw(ME);   
end

% check that first input argument is a numeric matrix
if any([~ismatrix(voltage),~isnumeric(voltage), length(voltage)==1])
    ME=MException('MATLAB: CalcPowerDC','voltage must be a numeric matrix with length > 1');
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
%if any([length(avgwindow)~=1, ~isnumerictype(avgwindow)])
%    ME=MException('MATLAB:CalcPowerDC','avgwindow must be a numeric scalar');
%    throw(ME);
%end

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

if any([time_current_compare(2) ~= 1, time_voltage_compare(2) ~= 1])
    ME=MException('MATLAB:CalcPowerDC','Time input is not same length as current or voltage dimension');
    throw(ME);
end

% Determining if the start and end times have be set
if nargin == 7
    ME=MException('MATLAB:CalcPowerDC','Invalid numer of arguments, if starttime is set, so does endtime');
    throw(ME);
end

if nargin == 8
    if any([~isscalar(starttime),~isnumerictype(starttime)])
        ME=MException('MATLAB:CalcPowerDC','Starttime needs to be a scalar of numeric type');
        throw(ME);
    end
    if any([~isscalar(endtime),~isnumerictype(endtime)])
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

current=current(:,startind:endind);
voltage=voltage(:,startind:endind);
daytime=daytime(:,startind:endind);
newtime=time(:,startind:endind);
datatime_len=time(endind)-time(startind);
window_len=samplerate*avgwindow;
n_windows=length(newtime)/window_len;
starti=1;
ind2=(1:n_windows)*window_len;
ind1=ind2(1:end-1)+1;
ind1=[1,ind1];
powerdata.starttime=daytime(ind1);
for i=1:n_windows
    powerdata.current(i)=current(:,ind1(i):ind2(i));
end
powerdata.current(4)
%    powerdata.current=[powerdata.current,current(:,ind1(i):ind2(i));
%disp(powerdata.current(2))
% for i=1:n_windows
%     endi=starti+window_len;    

% Calculating the Power and statistics and filling the power data structure


% eval(['powerdata(' num2str(i) ').current = current(:,starti:endi);']);
% eval(['powerdata(' num2str(i) ').voltage = voltage(:,starti:endi);']);
% eval(['powerdata(' num2str(i) ').starttime = daytime(starti);']);
% eval(['powerdata(' num2str(i) ').endtime = daytime(endi);']);

%starti=endi+1;

% powerdata.power = current.*voltage;
% powerdata.grosspower = sum(powerdata.power,2);
% powerdata.nchan = current_size(1);
% powerdata.props.samplerate = samplerate;
% powerdata.props.numSamples = time_size;
% powerdata.props.timeseriesduration = time_size*samplerate;
% 
% 
% powerdata.stats.chanavgcurrent = mean(current);
% powerdata.stats.chanavgvoltage = mean(voltage);
% powerdata.stats.chanavgpower = mean(powerdata.power);
% powerdata.stats.chanmaxcurrent = max(current);
% powerdata.stats.chanmaxvoltage = max(voltage);
% powerdata.stats.chanmaxpower = max(powerdata.power);
% powerdata.stats.chanmincurrent = min(current);
% powerdata.stats.chanminvoltage = min(voltage);
% powerdata.stats.chanminpower = min(powerdata.power);
% powerdata.stats.chanstdcurrent = std(current);
% powerdata.stats.chanstdvoltage = std(voltage);
% powerdata.stats.chanstdpower = std(powerdata.power);
% 
% powerdata.stats.grossavgpower = mean(powerdata.grosspower);
% powerdata.stats.grossmaxpower = max(powerdata.grosspower);
% powerdata.stats.grossminpower = min(powerdata.grosspower);
% powerdata.stats.grossstdpower = std(powerdata.grosspower);
% 
% disp(powerdata.stats.grossavgpower)

%end
%disp(powerdata.starttime)


end