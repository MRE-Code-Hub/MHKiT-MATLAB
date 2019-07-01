function powerdata=CalcPowerDC(voltage,current,time,samplerate)

% Calcuates the Time series of net power from voltage and current
% and populates the InitPowerData structure 
%
% Input:
%    voltage        Time series of measured volatege (V) of form 
%        [time , Nchannels]
%    current        Time series of the measured current (A) of form
%        [time , Nchanels]
%    time           measurement time vector (s)
%    samplerate     sample rate of time series in Hz
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
if nargin < 4 
    ME = MException('MATLAB: CalcPowerDC','Incorrect number of input arguments, reguires at lest 4 arguments, %d arguments passed',nargin);
    throw(ME);
end

if nargin > 4 
    ME = MException('MATLAB: CalcPowerDC',['Incorrect numner of input arguments, too many arguments, requires at most 4, %d arguments passed',nargin]);
    throw(ME);   
end

% check that first input argument is a numeric matrix
if any([~ismatrix(voltage),~isnumeric(voltage), length(voltage)==1])
    ME=MException('MATLAB: CalcPowerDC','voltage must be a numeric matrix with length > 1');
    throw(ME);
end

%check that the 2nd input argument is a numeric matrix
if any([~ismatrix(current),~isnumeric(current),length(current)==1])
    ME=MException('MATLAB: CalcPowerDC','Current must be a numeric matrix with lenght >1');
    throw(ME);
end

%check that the 3rd input argument is a numeric vector
if any([~isvector(time),~isnumeric(time),length(time)==1])
    ME=MException('MATLAB: CalcPowerDC','Time must be a numeric vector with lenght >1');
    throw(ME);
end

current_size = size(current);
voltage_size = size(voltage);
time_size = len(time);
time_current_compare = current_size == time_size;
time_voltage_compare = voltage_size == time_size;

% check that the current and voltage arrays are of the same size/dimensions
if ~isequal(current_size,voltage_size)
    ME=MException('MATLAB: CalcPowerDC','Current and voltage arrays must be same size');
    throw(ME);
end

% check that time and current/voltage have a dimension of the same length

if any([time_current_compare(1) ~= 1, time_voltage_compare(1) ~= 1])
    ME=MException('MATLAB: CalcPowerDC','Time input is not same length as current or voltage dimension');
    throw(ME);
end


% Calculating the Power and statistics and filling the power data structure


powerdata.current = current;
powerdata.voltage = voltage;
powerdata.power = current.*voltage;
powerdata.grosspower = sum(powerdata.power,2);
powerdata.nchan = current_size(1);
powerdata.props.samplerate = samplerate;
powerdata.props.numSamples = time_size;
powerdata.props.timeseriesduration = time_size*samplerate;


powerdata.stats.chanavgcurrent = mean(current);
powerdata.stats.chanavgvoltage = mean(voltage);
powerdata.stats.chanavgpower = mean(powerdata.power);
powerdata.stats.chanmaxcurrent = max(current);
powerdata.stats.chanmaxvoltage = max(voltage);
powerdata.stats.chanmaxpower = max(powerdata.power);
powerdata.stats.chanmincurrent = min(current);
powerdata.stats.chanminvoltage = min(voltage);
powerdata.stats.chanminpower = min(powerdata.power);
powerdata.stats.chanstdcurrent = std(current);
powerdata.stats.chanstdvoltage = std(voltage);
powerdata.stats.chanstdpower = std(powerdata.power);

powerdata.stats.grossavgpower = mean(powerdata.grosspower);
powerdata.stats.grossmaxpower = max(powerdata.grosspower);
powerdata.stats.grossminpower = min(powerdata.grosspower);
powerdata.stats.grossstdpower = std(powerdata.grosspower);







end