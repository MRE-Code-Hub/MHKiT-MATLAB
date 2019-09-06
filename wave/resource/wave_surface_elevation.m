function eta=wave_surface_elevation(S,time_index)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates time-series of wave amplitude from spectrum using random phase
%    
%    Parameters
%    ------------
%    S: Spectral Density (m^2-s)
%           Pandas data frame
%       To make a pandas data frame from user supplied frequency and spectra
%       use py.pandas_dataframe.spectra_to_pandas(frequency,spectra)
%
%    Optional Parameters
%    -------------------
%    start_time: float
%         Beginning of time-series (s)
%    dt: float
%         Time-step (s)
%    end_time: float
%         End of time-series (s)
%     
%    Returns
%    ---------
%    eta: pandas DataFrame
%         Wave surface elevation (m)
%
%    Dependancies 
%    -------------
%    Python 3.5 or higher
%    Pandas
%    Scipy
%    Numpy
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[own_path,~,~] = fileparts(mfilename('fullpath'));
modpath= fullfile(own_path, '...');
P = py.sys.path;
if count(P,'modpath') == 0
    insert(P,int32(0),'modpath');
end

py.importlib.import_module('mhkit');
py.importlib.import_module('pandas_dataframe');

if (isa(S,'py.pandas.core.frame.DataFrame')~=1)
    ME = MException('MATLAB:wave_surface_elevation','S needs to be a Pandas dataframe, use py.pandas_dataframe.spectra_to_pandas to create one');
    throw(ME);
end

% if nargin == 4 
%     start_time=varargin{1};
%     dt=varargin{2};
%     end_time=varargin{3};
%     eta=py.mhkit_wave_resource.surface_elevation(S,start_time,dt,end_time);
% else
eta=py.mhkit.wave.resource.surface_elevation(S,time_index);
end
    
    
