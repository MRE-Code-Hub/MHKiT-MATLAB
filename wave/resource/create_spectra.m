function wave_spectra=create_spectra(spectraType,frequency,Tp,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spectra,spectra_type,frequency=create_spectra(spectraType,frequency,Tp,varagin)
%Calculates wave spectra of user specified type
%    
%     Parameters
%     ------------
%     spectraType: String of spectra type
%         Options are: 'pierson_moskowitz_spectrum',
%         'bretschneider_spectrum', or 'jonswap_spectrum'
%     Frequency: float
%         Wave frequency (Hz)
%     Tp: float
%         Peak Period (s)
%     Optional Parameters
%     -------------------
%     Hs: float - Required for 'bretschneider_spectrum', and 'jonswap_spectrum'
%         Significant Wave Height (s)
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
%     Numpy
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

if (isa(frequency,'py.numpy.ndarray') ~= 1)
    frequency = py.numpy.array(frequency);
end

if strcmp(spectraType,'pierson_moskowitz_spectrum')
    S=py.mhkit.wave.resource.pierson_moskowitz_spectrum(frequency,Tp);
    
elseif strcmp(spectraType,'bretschneider_spectrum')
    if nargin ~= 4
         ME = MException('MATLAB:create_spectra','Hs is needed for bretschneider_spectrum');
         throw(ME);
    end
    S=py.mhkit.wave.resource.bretschneider_spectrum(frequency,Tp,varargin{1});

elseif strcmp(spectraType,'jonswap_spectrum')
    if nargin ~= 4
         ME = MException('MATLAB:create_spectra','Hs is needed for jonswap_spectrum');
         throw(ME);
    end
    S=py.mhkit.wave.resource.jonswap_spectrum(frequency,Tp,varargin{1});

else 
    ME = MException('MATLAB:create_spectra','Not a Valid Spectrum Type');
    throw(ME);
end

wave_spectra.spectrum=double(S.values);
char_arr=char(S.index.values);
indchar=strfind(char_arr,',');
wave_spectra.type=char_arr(3:indchar(1)-1);
wave_spectra.frequency=double(S.columns.values);
wave_spectra.Tp=Tp;
if nargin == 4 
    wave_spectra.Hs=varargin{1};
end



