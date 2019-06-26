function RunIssues = testMechPower(data,RunIssues)

% function RunIssues = testMechPower(LoadData)
%
% Executes the power performance functions and identifies any issues with 
% the functionality and calculations
%
% Input:
%   Data            A structure that contains the data used in the testing
%                   of the MHKiT functions
%   RunIssues       A structure that logs any issues encourntered during
%                   testing of the power performance scripts
% Output:
%   RunIssues       A structure that logs any issues encourntered during
%                   testing of the power performance scripts
% Dependencies
%   initMechPower, CalcMechPower
%
% Usage
%   RunIssues = testPowerPerformace(data,RunIssues)
%   runs the power performance module test scripts using data and logging
%   and issues in RunIssues

% running the test scripts and evaluating the results

disp('Test 1');
% calculate the mechanical power, test 1, no optional parameters, time
% series are vectors
waveSpectra1 = CalcMechPower(data.d1.kin(4000:end-4000),data.d1.dyn(4000:end-4000),data.d1.time(4000:end-4000),50);

disp('Test 2');
size([[data.d1.kin(4000:end-4000)];[data.d1.kin(4000:end-4000)];[data.d1.kin(4000:end-4000)]])
size([[data.d1.dyn(4000:end-4000)];[data.d1.dyn(4000:end-4000)];[data.d1.dyn(4000:end-4000)]])
% calculate the mechanical power, test 2, time series are matrices
waveSpectra2 = CalcMechPower([[data.d1.kin(4000:end-4000)];[data.d1.kin(4000:end-4000)];[data.d1.kin(4000:end-4000)]], ...
                             [[data.d1.dyn(4000:end-4000)];[data.d1.dyn(4000:end-4000)];[data.d1.dyn(4000:end-4000)]], ...
                               data.d1.time(4000:end-4000),50);



