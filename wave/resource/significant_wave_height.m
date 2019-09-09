function Hm0=significant_wave_height(S)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates wave height from spectra
%
%    Parameters
%     ------------
%     S: pandas DataFrame
%         Spectral Density (m^2/Hz)
%        OR
%        wave_spectra structure of form
%        wave_spectra.spectrum=Spectral Density (m^2-s;
%         wave_spectra.type=String of the spectra type, i.e. Bretschneider, 
%                time series, date stamp etc. ;
%         wave_spectra.frequency= frequency (Hz);
%         
%     Returns
%     ---------
%     Hm0: pandas Series 
%         Significant Wave Height (m)
%    From
%     # Eq 12 in IEC 62600-101
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
        S=py.pandas_dataframe.spectra_to_pandas(S.frequency,S.spectrum);
        disp(S);
    else
        ME = MException('MATLAB:significant_wave_height','S needs to be a Pandas dataframe, use py.pandas_dataframe.spectra_to_pandas to create one');
        throw(ME);
    end
end

Hm0=py.mhkit.wave.resource.significant_wave_height(S);
Hm0=double(Hm0.values);