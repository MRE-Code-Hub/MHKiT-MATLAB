function wave_spectra=elevation_spectrum(ts,sample_rate,nnft,time,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spectra=elevation_spectrum(ts,sampleRate,nnft)
%Calculates wave spectra from wave probe timeseries
%    
%     Parameters
%     ------------
%     ts: matrix or table
%           Wave probe time-series data, with each column a different time
%           series 
%     sampleRate: float
%           Data frequency (Hz)
%     nnft: int
%     time: vector or table
%           time (s)
%
%     Optional
%     ---------
%     window: string scalar 
%        Signal window type. "hamming" is used by default given the broadband 
%        nature of waves. See scipy.signal.get_window for more options.
%     detrend: logical
%        Specifies if a linear trend is removed from the data before calculating 
%        the wave energy spectrum.  Data is detrended by default.
%
%     Returns
%     ---------
%     wave_spectra: structure 
%         wave_spectra.spectrum: cell array
%            Spectral Density (m^2/Hz) per probe
%         wave_spectra.type: 'Spectra from Time Series'
%         wave_spectra.frequency: frequency [Hz] 
%         wave_spectra.sample_rate: sample_rate
%         wave_spectra.nnft: nnft
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
py.importlib.import_module('numpy');
if (isa(ts,'py.pandas.core.frame.DataFrame')~=1)
    if (isa(ts,'table')==1)
        ts=table2array(ts);
    end
    if (isa(time,'table')==1)
        time=table2array(time);
    end
    x=size(ts);
    li=py.list();
    if x(2)>1 
        for i = 1:x(2)
            app=py.list(ts(:,i));
            li=py.pandas_dataframe.lis(li,app);
            
        end
    ts=py.pandas_dataframe.timeseries_to_pandas(li,time,int32(x(2)));
    elseif x(2)==1
       ts=py.pandas_dataframe.timeseries_to_pandas(ts,time,int32(x(2))); 
    end
    
end
nnft=int32(nnft);
if nargin > 4
    if nargin > 6
        ME = MException('MATLAB:elevation_spectrum','Incorrect number of input arguments, too many agruments, requires 6 at most, %d arguments passed',nargin);
        throw(ME);
    
    elseif nargin == 5
        if any(isStringScalar(varargin{1}))
            spectra=py.mhkit.wave.resource.elevation_spectrum(ts,sample_rate,nnft,pyargs('window',varargin{1}));
        end
        if any([varargin{1}==true, varargin{1}==false])
            spectra=py.mhkit.wave.resource.elevation_spectrum(ts,sample_rate,nnft,pyargs('detrend',varargin{1}));
        end
        
    elseif any(isStringScalar(varargin{1})) & any([varargin{2}==true, varargin{2}==false])
        spectra=py.mhkit.wave.resource.elevation_spectrum(ts,sample_rate,nnft,pyargs('window',varargin{1},'detrend',varargin{2}));
    elseif any(isStringScalar(varargin{2})) & any([varargin{1}==true, varargin{1}==false])
        spectra=py.mhkit.wave.resource.elevation_spectrum(ts,sample_rate,nnft,pyargs('window',varargin{2}, 'detrend',varargin{1}));
    else
        ME = MException('MATLAB:elevation_spectrum','One or more optional argument is of the wrong type');
        throw(ME);
    end
else
    spectra=py.mhkit.wave.resource.elevation_spectrum(ts,sample_rate,nnft);
end


 vals=double(py.array.array('d',py.numpy.nditer(spectra.values)));
 sha=cell(spectra.values.shape);
 x=int64(sha{1,1});
 y=int64(sha{1,2});
 vals=reshape(vals,[x,y]);

si=size(vals);

wave_spectra.spectrum=vals;
% for i=1:si(2)
%    wave_spectra.spectrum{i}=vals(:,i);
%    wave_spectra.spectrum{i}=[wave_spectra.spectrum{i}];
% end
wave_spectra.type='Spectra from Timeseries';

wave_spectra.frequency=double(py.array.array('d',py.numpy.nditer(spectra.index)));
wave_spectra.sample_rate=sample_rate;
wave_spectra.nnft=nnft;

    