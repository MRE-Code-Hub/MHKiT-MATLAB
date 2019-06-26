function [capLengthMatrix,HmoBins,TeBins] = CalcCaptureLengthMatrix(capLength,Hmo,Te,HmoBinSize,TeBinSize,...
    HmoStartBin,HmoEndBin,TeStartBin,TeEndBin)

% Calculates the capture length Matrix frollowing the TS 62600-100 standards 
%
% Input:
%    capLength               Time series of the mcapture length (m) of form
%                     [time , Nchanels]
%    Hmo                     Significant wave height vector (m)
%    Te                      energy period vector (s)
%    HmoBinSize              Size of Hmo bins for the matrix
%    TeBinSIze               Size of the Te bins in the matrix
%    HmoStartBin             minimum Hmo value at which to start binning
%    HmoEndBin               maximum Hmo value at which to end binning 
%    TeStartBin              minimum Te value at which to start binning 
%    TeEndBin                maximim Te value at which to end binning 
%
% Output: 
%    captureLength          A matrix of capture length (m) with avg, min,
%                               max, stdev, and n-occurnaces within each bin
%    HmoBins                The bins of Hmo for the matrix
%    TeBins                 The Bins of Te for the matrix
%
% Dependancies: 
%        i
%        
%        
%
% Usage: 
%    CalcCaptureLengthMatrix(capLength,time,Hmo,Te,HmoBinSIze,TeBinSize,HmoStartBin,HmoEndBin,TeStartBin,TeEndBin)
%    calculates the capture length matrix
%    
%
% Version 1, 06/05/2019 Rebecca Pauly, NREL

% check to see if correct number of arguments were passed
if nargin < 9 
    ME = MException('MATLAB:CalcCaptureLengthMatrix','Incorrect number of input arguments, requires 9 arguments, %d arguments passed',nargin);
    throw(ME);
end

if nargin > 9 
    ME = MException('MATLAB:CalcCaptureLengthMatrix','Incorrect number of input arguments, too many arguments, requires at most 9, %d arguments passed',nargin);
    throw(ME);   
end

% check that first input argument is a numeric matrix
if any([~ismatrix(capLength),~isnumeric(capLength), length(capLength)==1])
    ME=MException('MATLAB:CalcCaptureLenghtMatrix','CapLength must be a numeric matrix with length > 1');
    throw(ME);
end

%check that the 5th input argument is a numeric matrix
if any([~ismatrix(Hmo),~isnumeric(Hmo),length(Hmo)==1])
    ME=MException('MATLAB:CalcCaptureLengthMatrix','Hmo must be a numeric matrix with lenght >1');
    throw(ME);
end

%check that the 6th input argument is a numeric matrix
if any([~ismatrix(Te),~isnumeric(Te),length(Te)==1])
    ME=MException('MATLAB:CalcCaptureLengthMatrix','Te must be a numeric matrix with lenght >1');
    throw(ME);
end

if any([length(HmoBinSize)~=1,~isnumeric(HmoBinSize)])
        ME=MException('MATLAB:CalcCaptureLenghtMatrix','HmoBinSize needs to be a scalar of numeric type');
        throw(ME);
end

if any([length(TeBinSize)~=1,~isnumeric(TeBinSize)])
        ME=MException('MATLAB:CalcCaptureLengthMatrix','TeBinSize needs to be a numeric type scalar');
        throw(ME);
end

if any([length(HmoStartBin)~=1,~isnumeric(HmoStartBin)])
        ME=MException('MATLAB:CalcCaptureLenghtMatrix','HmoStartBin needs to be a scalar of numeric type');
        throw(ME);
end

if any([length(TeStartBin)~=1,~isnumeric(TeStartBin)])
        ME=MException('MATLAB:CalcCaptureLengthMatrix','TeStartBin needs to be a numeric type scalar');
        throw(ME);
end

if any([length(HmoEndBin)~=1,~isnumeric(HmoEndBin)])
        ME=MException('MATLAB:CalcCaptureLenghtMatrix','HmoEndBin needs to be a scalar of numeric type');
        throw(ME);
end

if any([length(TeEndBin)~=1,~isnumeric(TeEndBin)])
        ME=MException('MATLAB:CalcCaptureLengthMatrix','TeEndBin needs to be a numeric type scalar');
        throw(ME);
end

if any(HmoEndBin < HmoStartBin+HmoBinSize)
        ME=MException('MATLAB:CalcCaptureLenghtMatrix','HmoEndBin needs to be greater than HoStartBin+HmoBinSize');
        throw(ME);
end

if any(TeEndBin < TeStartBin+TeBinSize)
        ME=MException('MATLAB:CalcCaptureLengthMatrix','TeEndBin needs to be greater than TeStartBin+TeBinSize');
        throw(ME);
end


% check that the Hmo and waveEnergy arrays are of the same size/dimensions
if ~isequal(length(Hmo),length(capLength))
    ME=MException('MATLAB:CalcCaptureLenghtMatrix','Hmo and capLength arrays must have the same length');
    throw(ME);
end

% check that the Te and waveEnergy arrays are of the same size/dimensions
if ~isequal(length(Te),length(capLength))
    ME=MException('MATLAB:CalcCaptureLenghtMatrix','Te and capLength arrays must have the same length');
    throw(ME);
end

nHmoBins=(HmoEndBin-HmoStartBin)/HmoBinSize;
nTeBins=(TeEndBin-TeStartBin)/TeBinSize;
HmoBins=HmoStartBin:HmoBinSize:HmoEndBin;
TeBins=TeStartBin:TeBinSize:TeEndBin;
capLengthMatrix=zeros(length(HmoBins),length(TeBins),5);

for i=1:length(TeBins)
    xTe=(Te > TeBins(i)-TeBinSize & Te <= TeBins(i)+TeBinSize);    
    for j=1:length(HmoBins)
        xHmo=(Hmo > HmoBins(j)-HmoBinSize & Hmo <= HmoBins(j)+HmoBinSize);
        xx=capLength(xHmo==1 & xTe==1);
        if ~isempty(xx)           
            capLengthMatrix(j,i,1)=mean(capLength(xHmo==1 & xTe==1));
            capLengthMatrix(j,i,2)=std(capLength(xHmo==1 & xTe==1));            
            capLengthMatrix(j,i,3)=max(capLength(xHmo==1 & xTe==1));
            capLengthMatrix(j,i,4)=min(capLength((xHmo==1) & (xTe==1)));
            capLengthMatrix(j,i,5)=length(capLength(xHmo==1 & xTe==1));
        end
    end
end
        










