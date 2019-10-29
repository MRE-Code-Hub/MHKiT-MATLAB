function datast=read_NDBC_file(file_name,varargin)

%%%%%%%%%%%%%%%%%%%%
%  Reads a NDBC wave buoy data file (from https://www.ndbc.noaa.gov) into a
%     structure.
%     
%     Realtime and historical data files can be loaded with this function.  
%     
%     Note: With realtime data, missing data is denoted by "MM".  With historical 
%     data, missing data is denoted using a variable number of 
%     # 9's, depending on the data type (for example: 9999.0 999.0 99.0).
%     'N/A' is automatically converted to missing data.
%     
%     Data values are converted to float/int when possible. Column names are 
%     also converted to float/int when possible (this is useful when column 
%     names are frequency).
%     
%     Parameters
%     ------------
%     file_name : string
%         Name of NDBC wave buoy data file
%     
%     Optional
%     ------------
%     varagin: missing_value : vector of values
%         vector of values that denote missing data    
%     
%     Returns
%     ---------
%     data: pandas DataFrame 
%         Data indexed by datetime with columns named according to header row 
%         
%     metadata: dict or None
%         Dictionary with {column name: units} key value pairs when the NDBC file  
%         contains unit information, otherwise None is returned

[own_path,~,~] = fileparts(mfilename('fullpath'));
modpath= fullfile(own_path);
P = py.sys.path;

if count(P,modpath) == 0
    insert(P,int32(0),modpath);
end

py.importlib.import_module('mhkit');
py.importlib.import_module('numpy');

if nargin == 2
    missing=py.list(varagin{1});
    datatp=py.mhkit.wave.io.read_NDBC_file(file_name,missing);
elseif nargin > 2
    ME = MException('MATLAB:read_NDBC_file','too many arguments passed');
    throw(ME);
else
    datatp=py.mhkit.wave.io.read_NDBC_file(file_name);
end

datac=cell(datatp);
datapd=datac{1};
disp(datapd)
xx=cell(datapd.axes);
v=xx{2};


vv=cell(py.list(py.numpy.nditer(v.values,pyargs("flags",{"refs_ok"}))));

vals=double(py.array.array('d',py.numpy.nditer(datapd.values)));
sha=cell(datapd.values.shape);
x=int64(sha{1,1});
y=int64(sha{1,2});

vals=reshape(vals,[x,y]);
ti=cell(py.list(py.numpy.nditer(datapd.index)));
siti=size(ti)
si=size(vals);
 for i=1:si(2)
    test=string(py.str(vv{i}));
    
    datast.(test)=vals(:,i);
 end
 for i=1:siti(2)
    datast.time{i}=string(py.str(ti{i}));
 end

