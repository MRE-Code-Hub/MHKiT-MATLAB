function J=energy_flux(S,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%    
%    Parameters
%    ------------
%    S: Spectral Density (m^2-s)
%           Pandas data frame
%       To make a pandas data frame from user supplied frequency and spectra
%       use py.pandas_dataframe.spectra_to_pandas(frequency,spectra)
%    h: float
%         Water depth (m)
%         
%
%     Returns
%     -------
%     J: float
%         Omni-directional wave energy flux (W/m)
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
    ME = MException('MATLAB:energy_flux','S needs to be a Pandas dataframe, use py.pandas_dataframe.spectra_to_pandas to create one');
    throw(ME);
end

if nargin == 2 
    h=varargin{1};
    J=py.mhkit.wave.resource.energy_flux(S,h);
else
    J=py.mhkit.wave.resource.energy_flux(S);
end