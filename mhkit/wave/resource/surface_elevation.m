function wave_elevation=surface_elevation(S,time_index,varargin)

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
%         wave_spectra.frequency= frequency (Hz);
%    time_index: array
%        Time used to create the wave elevation time series [s],
%        
%    Optional Parameters
%    -------------------
%    seed: Int
%        random seed
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
py.importlib.import_module('numpy');

if (isa(time_index,'py.numpy.ndarray') ~= 1)
    time_index = py.numpy.array(time_index);
end

if (isa(S,'py.pandas.core.frame.DataFrame')~=1)
    if (isstruct(S)==1)
        x=size(S.spectrum);
        li=py.list();
        if x(2)>1 
            for i = 1:x(2)
                app=py.list(S.spectrum(:,i));
                li=py.pandas_dataframe.lis(li,app);
            
            end
            S=py.pandas_dataframe.spectra_to_pandas(uint32(S.frequency),li,int32(x(2)));
        elseif x(2)==1
            S=py.pandas_dataframe.spectra_to_pandas(uint32(S.frequency),py.numpy.array(S.spectrum),int32(x(2)));
        end
    else
        ME = MException('MATLAB:significant_wave_height','S needs to be a Pandas dataframe, use py.pandas_dataframe.spectra_to_pandas to create one');
        throw(ME);
    end
end

 if nargin == 4 
     seed=varagin{1};
     eta=py.mhkit_wave_resource.surface_elevation(S,time_index,pyargs('seed',seed));
 else
     eta=py.mhkit.wave.resource.surface_elevation(S,time_index);
 end

vals=double(py.array.array('d',py.numpy.nditer(eta.values)));
 sha=cell(eta.values.shape);
 x=int64(sha{1,1});
 y=int64(sha{1,2});
 vals=reshape(vals,[x,y]);

si=size(vals);
wave_elevation.spectrum=cell2mat(vals);
% for i=1:si(2)
%    wave_elevation.spectrum{i}=vals(:,i);
% end

wave_elevation.type='Time Series from Spectra';

wave_elevation.time=double(py.array.array('d',py.numpy.nditer(eta.index)));

    
    
