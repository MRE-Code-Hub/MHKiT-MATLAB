function RunIssues = TestData(functionName, CompLog, TargetData, TestData, RunIssues,INDX)

% forming the index string
INDXStr = ['(' num2str(INDX(1))];
for i = 2:length(INDX)
    INDXStr = [INDXStr ',' num2str(INDX(i))];
end;
INDXStr = [INDXStr ')'];

if TargetData == TestData
    eval(['RunIssues.' functionName '.' CompLog  INDXStr ' = 1;'])
else
    eval(['RunIssues.' functionName '.' CompLog  INDXStr ' = 0;'])
end;