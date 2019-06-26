function plot=CaptureLengthMatrixPlot(capLenMatrix,HmoBins,TeBins,stat,varargin)

% Produce a graphic of the capture length matrix following the TS 62600-100 standards 
%
% Input:
%    caplenMatrix               Matrix of a stat in the capture length matrix. One
%                                   stat should be ebtered at a time, i.e. avg,
%                                   min, max,or stdev. size: [Hmo , Te]
%    HmoBins                    Vector of Hmo bins used in the capture
%                                   length matrix. [m]                    
%    TeBins                     Vector of Te used in the capture length
%                                   matrix [s]
%    stat                       The statistic from the matrix you are
%                                   displaying 
%    Optional Parameters:
%    minHmo                     the minimum Hmo value you wish to display
%                                   [m]
%    maxHmo                     The max Hmo value you wish to display [m]
%    minTe                      The min Te value you wish to display [s]
%    maxTe                      The max Te value you wish to display [s]
%    Note: if one optional argument is given, they all must be given 
%
%
% Output: 
%    plot          Plot of capture Lenght matrix
%
% Dependancies: 
%       
%        
%
% Usage:
%    CaptureLengthMatrixPlot(CapLenMatrix,HmoBins,Tebins,stat)
%    produces plot of capture length matrix for selected statistic with
%    whole matrix ploted with default plot limits 

%    CaptureLengthMatrixPlot(CapLenMatrix,HmoBins,Tebins,stat,mimHmo,maxHmo,minTe)
%    produces plot of capture length matrix for selected statistic with
%    plot limits set
%    
%
% Version 1, 06/12/2019 Rebecca Pauly, NREL

% check to see if correct number of arguments were passed
if nargin < 4 
    ME = MException('MATLAB:CaptureLengthMatrixPlot','Incorrect number of input arguments, requires 4 arguments, %d arguments passed',nargin);
    throw(ME);
end

if nargin > 8 
    ME = MException('MATLAB:CaptureLengthMatrixPlot',['Incorrect number of input arguments, too many arguments, requires at most 8, %d arguments passed',nargin]);
    throw(ME);   
end

%check that the 1st input argument is a numeric matrix
if any([~ismatrix(capLenMatrix),~isnumeric(capLenMatrix),length(capLenMatrix)==1])
    ME=MException('MATLAB:CaptureLengthMatrixPlot','capLenMatrix must be a numeric matrix with lenght >1');
    throw(ME);
end

%check that the 2nd input argument is a numeric vector
if any([~isvector(HmoBins),~isnumeric(HmoBins),length(HmoBins)==1])
    ME=MException('MATLAB:CaptureLengthMatrixPlot','HmoBins must be a numeric vector with lenght >1');
    throw(ME);
end

%check that the 3rd input argument is a numeric vector
if any([~isvector(TeBins),~isnumeric(TeBins),length(TeBins)==1])
    ME=MException('MATLAB:CaptureLengthMatrixPlot','TeBins must be a numeric vector with lenght >1');
    throw(ME);
end

if any([numel(stat)~=1,~isstring(stat)])
        ME=MException('MATLAB:CaptureLengthMatrixPlot','stat needs to be a string of length 1');
        throw(ME);
end

clSize=size(capLenMatrix);

if any([clSize(1) ~= length(HmoBins)])
        ME=MException('MATLAB:CaptureLengthMatrixPlot','capLenMatrix needs the same number of rows as length of HmoBins');
        throw(ME);
end

if any([clSize(2) ~= length(TeBins)])
        ME=MException('MATLAB:CaptureLengthMatrixPlot','capLenMatrix needs the same number of columns as length of TeBins');
        throw(ME);
end

if any([nargin == 7, nargin ==6, nargin == 5])
    ME=MException('MATLAB:CaptureLengthMatrixplot','Invalid numer of arguments, if one optional argument is set, they all must be set');
    throw(ME);
end

if nargin == 8
    minHmo=varargin{1};
    maxHmo=varargin{2};
    minTe=varargin{3};
    maxTe=varargin{4};
    
    if any([length(minHmo)~=1,~isnumeric(minHmo)])
        ME=MException('MATLAB:CaptureLengthMatrixPlot','minHmo needs to be a numeric type scalar');
        throw(ME);
    end

    if any([length(maxHmo)~=1,~isnumeric(maxHmo)])
        ME=MException('MATLAB:CaptureLengthMatrixPlot','maxHmo needs to be a numeric type scalar');
        throw(ME);
    end

    if any([length(minTe)~=1,~isnumeric(minTe)])
        ME=MException('MATLAB:CaptureLengthMatrixPlot','minTe needs to be a numeric type scalar');
        throw(ME);
    end

    if any([length(maxTe)~=1,~isnumeric(maxTe)])
        ME=MException('MATLAB:CaptureLengthMatrixPlot','maxTe needs to be a numeric type scalar');
        throw(ME);
    end
else
   minHmo=min(HmoBins);
   maxHmo=max(HmoBins);
   minTe=min(TeBins);
   maxTe=max(TeBins);
end

pcolor(TeBins,HmoBins,capLenMatrix)
colormap(flipud(hot))
ylabel('Hm0 [m]','FontSize',20)
xlabel('Te [s]','FontSize',20)
title('Capture Length','FontSize',40)
colorbar
    






