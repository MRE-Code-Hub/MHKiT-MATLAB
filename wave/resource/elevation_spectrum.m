function wave_spectra=elevation_spectrum(ts,sampleRate,nnft,time)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spectra=elevation_spectrum(ts,sampleRate,nnft)
%Calculates wave spectra from wave probe timeseries
%    
%     Parameters
%     ------------
%     ts: Wave probe time-series data
%     sampleRate: float
%         Data frequency (Hz)
%     nnft: int
%     time: epoch time (s)
%     
%     Returns
%     ---------
%     S: pandas DataFrame 
%         Spectral Density (m^2/Hz) per probe
%
%     Dependancies 
%     -------------
%     Python 3.5 or higher
%     Pandas
%     Scipy
%     pandas_dataframe.py
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

 ts=py.numpy.array(ts);
 if (isa(ts,'py.pandas.core.frame.DataFrame')~=1)
     ts=py.pandas_dataframe.timeseries_to_pandas(ts,time);
 end

nnft=int32(nnft);
spectra=py.mhkit.wave.resource.elevation_spectrum(ts,sampleRate,nnft);

wave_spectra.spectrum=double(spectra.values);

wave_spectra.type='Spectra from Timeseries';
wave_spectra.frequency=double(spectra.columns.values);
wave_spectra.sampleRate=sampleRate;
wave_spectra.nnft=nnft;

    