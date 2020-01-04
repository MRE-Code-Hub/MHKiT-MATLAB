function results = qc_range(data, range, varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Check for data that is outside expected range
%    
% Parameters
% ------------
%
%     data: pandas dataframe or qcdata structure
%          Pandas dataframe indexed by datetime (use 
%          py.mhkit_python_utils.pandas_dataframe.timeseries_to_pandas(ts,time,x))
%
%          OR
%     
%          qcdata structure of form:
%
%             data.values: 2D array of doubles with arbitrary number of columns
%             data.time:   1D array of datetimes or posix times
%
%     range: list of floats
%         [lower bound, upper bound] for range checking
%         NaN or py.None can be used for either bound 
%
%     key: string (optional)
%         Data column name or translation dictionary key.  If not specified
%         or set to py.None, all columns are used for test.
%
%     min_failures: int (optional)
%         Minimum number of consecutive failures required for reporting
%         default = 1
%
%     Must set previous arguments to use later optional arguments
%     (i.e. must set key to use min_failures).
%     
% Returns
% ---------
%     results: qcdata structure of form:
%
%         results.values: array of doubles
%            Same shape as input data.values
%            Elements that failed QC test replaced with NaN 
%
%         results.mask: array of int64
%            Same shape as input data.values
%            Logical mask of QC results (1 = passed, 0 = failed QC test) 
%
%         results.time: array of datetimes
%            Same as input times 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  py.importlib.import_module('pecos');

  % check to see if a pandas dataframe or not
  if (isa(data,'py.pandas.core.frame.DataFrame')~=1)
    data=qc_data_to_dataframe(data);
  end
  
  % Must use optional qc arguments in order, for now.
  if nargin == 2
    r = struct(py.pecos.monitoring.check_range(data, range));
  elseif nargin == 3
    r = struct(py.pecos.monitoring.check_range(data,range,varargin{1}));
  elseif nargin == 4
    r = struct(py.pecos.monitoring.check_range(data,range,varargin{1},varargin{2}));
  else
    ME = MException('MATLAB:qc_range','incorrect number of arguments (2 to 4)');
        throw(ME);
  end

  % Convert to qcdata structure
  results.values=double(r.cleaned_data.values);
  results.mask=int64(r.mask.values);

  % Extract time from index, convert to posix then datetime
  ptime = double(py.array.array('d',py.numpy.nditer(r.cleaned_data.index.values)))/1e9;
  results.time=datetime(ptime,'ConvertFrom','posix');

end 
