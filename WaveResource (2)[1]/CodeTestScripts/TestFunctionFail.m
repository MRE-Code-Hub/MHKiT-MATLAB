
function [RunIssues,testID] = TestFunctionFail(functionName, message, testPurpose, RunIssues, testID, varargin);


% building the function call
functionCall = [functionName '('];
if nargin > 6
    for inputIdx = 6:nargin
        if inputIdx == 6
            functionCall = [functionCall 'varargin{' num2str(inputIdx-5), '}'];
        else
        functionCall = [functionCall ',varargin{' num2str(inputIdx-5), '}'];
        end;
    end;
end;

functionCall = [functionCall ');'];

try
    CallFail = 0;
    eval(functionCall);
catch ME
    % perform string comparision here
    if strcmp(ME.message,message)
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').success = 1;']);
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').type = ''errorCatchTest'';']);
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').message = ''' ME.message ''';']);
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').intendedMessage = ''' message ''';']);
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').Purpose = ''' testPurpose ''';']);
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').issue = ''none'';']);
    else
        % if the wrong message was send, flag that
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').success = 0;']);
        eval(['RunIssues.' functionName '.FailTest(' num2str(testID), ').type = ''errorCatchTest'';']);        
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

% incrementing the testID variable
testID = testID + 1;
