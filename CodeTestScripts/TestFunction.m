function [RunIssues, functionOutput] = TestFunction(functionName, testPurpose, RunIssues, testID, varargin);


% building the input and output arguments
input = [];
output = ['['];
fnBuildCall = [];
outputVars = [];
if nargin > 5
    for Idx = 5:nargin
        %check if these are input or output arguments
        if  strcmp(varargin{Idx-4}, 'output');
            fnBuildCall = 'output';
        elseif strcmp(varargin{Idx-4},'input');
            fnBuildCall = 'input';
        else
            if strcmp(fnBuildCall, 'output');
                output = [output, varargin{Idx-4}, ','];
                outputVars = [outputVars, varargin(Idx-4)];
            elseif strcmp(fnBuildCall,'input');
                input = [input, 'varargin{' num2str(Idx-4), '},'];
            else
                error('input or output identifieers not used in the input agrument to the function call');
            end;
        end;
    end;
    % building the function call
    if isempty(output)
        functionCall = [functionName '('];
    else
        % dropping off the last comma
        output = output(1:length(output)-1);
        functionCall = [output '] = ' functionName '('];
    end;
    
    if isempty(input)
        functionCall = [functionCall ');'];
    else
        % dropping off the last comma
        input = input(1:length(input)-1);
        functionCall = [functionCall input ');'];
    end;
    
end;

%functionCall

try
    CallFail = 0;
    eval(functionCall);
catch ME
        %disp('fail');
        eval(['RunIssues.' functionName '.FunctionTest(' num2str(testID), ').success = 0;']);
        eval(['RunIssues.' functionName '.FunctionTest(' num2str(testID), ').type = ''functionRunTest'';']);
        disp(ME.message)
        eval(['RunIssues.' functionName '.FunctionTest(' num2str(testID), ').message = ''' ME.message ''';']);
        %ME.message
        eval(['RunIssues.' functionName '.FunctionTest(' num2str(testID), ').Purpose = ''' testPurpose ''';']);
        eval(['RunIssues.' functionName '.FunctionTest(' num2str(testID), ').issue = ''Did not run'';']);
        CallFail = 1;
end;

if CallFail == 0;
        %disp('pass');
        eval(['RunIssues.' functionName '.FunctionTest(' num2str(testID), ').success = 1;']);
        eval(['RunIssues.' functionName '.FunctionTest(' num2str(testID), ').type = ''functionRunTest'';']);
        eval(['RunIssues.' functionName '.FunctionTest(' num2str(testID), ').message = [];']);
        eval(['RunIssues.' functionName '.FunctionTest(' num2str(testID), ').Purpose = ''' testPurpose ''';']);
        eval(['RunIssues.' functionName '.FunctionTest(' num2str(testID), ').issue = ''none'';']);
end;

% creating the output variable
for Idx = 1:length(outputVars)
    %['functionOutput.' outputVars{Idx} ' = ' outputVars{Idx} ';']
    eval(['functionOutput.' outputVars{Idx} ' = ' outputVars{Idx} ';']); 
end;
%functionOutput

