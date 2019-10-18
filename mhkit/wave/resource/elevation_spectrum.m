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
py.importlib.import_module('numpy');
disp('in');
 x=size(ts);
%     ts_dict=py.dict();
li=py.list(ts(:,1));
if x(2)>1 
    
     for i = 2:x(2)
         li=py.list({li,py.list(ts(:,i))})
%         j=string(i);
%         dict_u=py.dict(pyargs(j,ts(:,i)));
%         ts_dict=py.dict(pyargs(**ts_dict,**dict_u));
     end
end
%ts=py.numpy.asarray(ts.');
disp('sucess')
if (isa(ts,'py.pandas.core.frame.DataFrame')~=1)
    ts=py.pandas_dataframe.timeseries_to_pandas(li,time,int32(x(2)));
end

nnft=int32(nnft);
ts
spectra=py.mhkit.wave.resource.elevation_spectrum(ts,sampleRate,nnft);

wave_spectra.spectrum=double(py.array.array('d',py.numpy.nditer(spectra.values)));

wave_spectra.type='Spectra from Timeseries';
wave_spectra.frequency=double(py.array.array('d',py.numpy.nditer(spectra.columns.values)));
wave_spectra.sampleRate=sampleRate;
wave_spectra.nnft=nnft;

    