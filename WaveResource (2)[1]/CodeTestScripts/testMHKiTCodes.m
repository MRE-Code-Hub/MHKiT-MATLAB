function RunIssues = testMHKiTCodes(varargin)

% function RunIssues = testMHKiTCodes(RunTestScripts,LoadData)
%
% Executes the MHKiT sfunctions and identifies any issues with the
% functionality and calculations

% Input:
%   RunTestScripts (optional) a cell list of the test scripts to execute, if
%                             if empty, [], or not used, all of the test
%                             scripts are executed.
%   LoadData(optional)        flag to determine whether to force the data
%                             to load, 'LoadData. The test data are
%                             automatically loaded on the first run;
%                             however, this flag is used if those data need
%                             need to be reloaded.
% Output:
%   RunIssues       A structure that logs any issues encourntered during
%                   testing of the MHKiT module scripts
%
% Usage
%   RunIssues = testMHKiTCodes(LoadData)
%   runs the MHKiT module test scripts. The test data are
%   automatically loaded on the first run, however, if LoadData = 1, the
%   test data are reloaded


% Initalizing variables
persistent data;

% setting path
BaseDirectory = 'C:\Users\fdriscol\Desktop\MHKiT\matlab';
addpath(genpath(BaseDirectory),'-begin')


loadData = 0;
MHKiTTestScripts = [];

% if the datafile is empty, set the variable to load the data
if isempty(data)
    loadData = 1;
end;

if nargin >= 1
    for argIdx = 1:nargin
        
        if iscell(varargin{argIdx})
            % setting the list of modules to test
            MHKiTTestScripts = varargin{argIdx};
        elseif varargin{argIdx} == 'LoadData'
            % setting the variable to force data to be loaded
            loadData = 1;
        end;
    end;
end;

% loading the data that is used in the function testing
if loadData
    disp('Loading WEP Data for AquaHarmonics');
    dataSets = [8,9];
    filenames = [{'SPOT #7.dat'},{'SPOT #8.dat'},{'SPOT #9.dat'}, ...
        {'SPOT #10.dat'},{'SPOT #11.dat'},{'SPOT #12.dat'},{'SPOT #17.dat'}, ...
        {'SPOT #18.dat'},{'SPOT #19.dat'},{'SPOT #20.dat'},{'SPOT #21.dat'},...
        {'SPOT #22.dat'},{'SPOT #23.dat'},{'SPOT #26.dat'},{'SPOT #27.dat'},...
        {'SPOT #29.dat'},{'SPOT #37.dat'},{'SPOT #38.dat'},{'SPOT #40.dat'},...
        {'SPOT #42.dat'},{'SPOT #43.dat'},{'SPOT #44.dat'},{'SPOT #45.dat'}, ...
        {'SPOT #47.dat'},{'SPOT #48.dat'},{'SPOT #49.dat'},{'SPOT #50.dat'}];
    % step through and load each spot data file number contained in dataSets
    for setIdx = 1:length(dataSets)
        % loading the individual data file
        eval(['[data.d' num2str(setIdx) '.data, header] = loadTimeSeriesAsciiData([filenames{' num2str(dataSets(setIdx)) '}],''\t'',18);']);
        
        % getting rid of the nan created by the leading tab
        eval(['data.d' num2str(setIdx) '.data = data.d' num2str(setIdx) '.data(:,2:end);']);
        eval(['data.d' num2str(setIdx) '.time = data.d' num2str(setIdx) '.data(:,1);']);
        eval(['data.d' num2str(setIdx) '.sampleRate = 1/(data.d' num2str(setIdx) '.time(2) - data.d' num2str(setIdx) '.time(1));']);
        eval(['data.d' num2str(setIdx) '.kin = data.d' num2str(setIdx) '.data(:,26);']);
        eval(['data.d' num2str(setIdx) '.dyn = data.d' num2str(setIdx) '.data(:,2);']);
        eval(['data.d' num2str(setIdx) '.wave1 = data.d' num2str(setIdx) '.data(:,20)*0.0254;']);
        eval(['data.d' num2str(setIdx) '.wave2 = data.d' num2str(setIdx) '.data(:,21)*0.0254;']);
        
        % setting the parameters for the data set
        eval(['data.d' num2str(setIdx) '.waterDensity = 1000;']);
        eval(['data.d' num2str(setIdx) '.waterDepth = 5.1;']);
        eval(['data.d' num2str(setIdx) '.freqRange = [0.2 2];']);
    end;
end;

% if the input argument RunTestScripts is not set, the run all of the
% test scripts
if isempty(MHKiTTestScripts)
    MHKiTTestScripts = {'PowerPerformance','WaveResource'};
end;

RunIssues = [];


if any(contains(MHKiTTestScripts,'PowerPerformance'))
    disp('Running Power Performance Scripts');
    %RunIssues = testMechPower(data,RunIssues)
end;

if any(contains(MHKiTTestScripts,'WaveResource'))
    disp('Running Wave Resource Scripts');
    RunIssues = testSpectra(data,RunIssues);
end;

RunIssues
% % Specifiying the metadata
% parameters = initParameters();







