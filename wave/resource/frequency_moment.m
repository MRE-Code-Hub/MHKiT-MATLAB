function m=frequency_moment(S,N)

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
%    N: int
%       Moment (0 for 0th, 1 for 1st ....)
%
%    Returns
%    ---------
%    m: pandas DataFrame 
%        Frequency Moment per spectrum
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

%Spd=py.pandas_dataframe.spectra_to_pandas(frequency,S);
if (isa(S,'py.pandas.core.frame.DataFrame')~=1)
    ME = MException('MATLAB:frequency_moment','S needs to be a Pandas dataframe, use py.pandas_dataframe.spectra_to_pandas to create one');
    throw(ME);
end
%disp(class(Spd))
m=py.mhkit.wave.resource.frequency_moment(S,0);