
function [RunIssues] = TestFunctionFail(functionName, message, testPurpose, RunIssues, testID, varargin);


% building the input and output arguments
input = [];
output = ['['];
fnBuildCall = [];
if nargin > 6
    for Idx = 6:nargin
        %check if these are input or output arguments
        if  strcmp(varargin{Idx-5}, 'output');
            fnBuildCall = 'output';
        elseif strcmp(varargin{Idx-5},'input');
            fnBuildCall = 'input';
        else
            if strcmp(fnBuildCall, 'output');
                output = [output, varargin{Idx-5}, ','];
            elseif strcmp(fnBuildCall,'input');
                input = [input, 'varargin{' num2str(Idx-5), '},'];
            else
                error('input or output identifieers not used');
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
    % perform string comparision here
    if strcmp(ME.message,message)
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').success = 1;']);
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').type = ''errorCatchTest'';']);
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').message = ''' ME.message ''';']);
        %ME.message
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').intendedMessage = ''' message ''';']);
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').Purpose = ''' testPurpose ''';']);
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').issue = ''none'';']);
    else
        % if the wrong message was send, flag that
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').success = 0;']);
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').type = ''errorCatchTest'';']);
        %ME.message
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').message = ''' ME.message ''';']);
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').intendedMessage = ''' message ''';']);
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').Purpose = ''' testPurpose ''';']);
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').issue = ''wrong error message'';']);
    end;
    CallFail = 1;
end;

% the function should have failed, if not, something is wrong and flag that
if CallFail == 0
    eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').success = 0;']);
    eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').type = ''errorCatchTest'';']);
    eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').message = [];']);
    eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').intendedMessage = [];']);
    eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').Purpose = ''' testPurpose ''';']);
    eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').issue = ''no error, function call should have thrown an error'';']);
end;


