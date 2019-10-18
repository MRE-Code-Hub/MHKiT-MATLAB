function eta=surface_elevation(S,time_index)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates time-series of wave amplitude from spectrum using random phase
%    
%    Parameters
%    ------------
%    S: Spectral Density (m^2-s)
%           Pandas data frame
%       To make a pandas data frame from user supplied frequency and spectra
%       use py.pandas_dataframe.spectra_to_pandas(frequency,spectra)
%        OR
%        wave_spectra structure of form
%        wave_spectra.spectrum=Spectral Density (m^2-s;
%         wave_spectra.type=String of the spectra type, i.e. Bretschneider, 
%                time series, date stamp etc. ;
%         wave_spectra.frequency= frequency (Hz);
%
%    Optional Parameters
%    -------------------
%    seed: random seed
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
%py.importlib.import_module('pandas_dataframe');

if (isa(S,'py.pandas.core.frame.DataFrame')~=1)
    if (isstruct(S)==1)
        S=py.pandas_dataframe.spectra_to_pandas(S.frequency,py.numpy.array(S.spectrum));
        disp(S);
    else
        ME = MException('MATLAB:significant_wave_height','S needs to be a Pandas dataframe, use py.pandas_dataframe.spectra_to_pandas to create one');
        throw(ME);
    end
end

 if nargin == 4 
     seed=varagin{1};
     eta=py.mhkit_wave_resource.surface_elevation(S,time_index,seed);
 else
eta=py.mhkit.wave.resource.surface_elevation(S,time_index);
 end
%disp(type(eta.values))
wave_spectra.surface_elevation=uint32(eta.values);

wave_spectra.type='Time Series from Spectra';
wave_spectra.time=eta.columns;

    
    
