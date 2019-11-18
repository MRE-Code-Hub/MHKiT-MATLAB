function wave_spectra=create_spectra(spectra_type,frequency,Tp,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Calculates wave spectra of user specified type
%    
% Parameters
% ------------
%     spectraType: String of spectra type
%         Options are: 'pierson_moskowitz_spectrum',
%         'bretschneider_spectrum', or 'jonswap_spectrum'
%
%     Frequency: float
%         Wave frequency (Hz)
%
%     Tp: float
%         Peak Period (s)
%
%     Hs: float - Required for 'bretschneider_spectrum', and 'jonswap_spectrum'
%         Significant Wave Height (s)
%
%     gamma: float (optional)
%         only an optional parameter for 'jonswap_spectrum'
%     
% Returns
% ---------
%     wave_spectra: structure
%
%         wave_spectra.spectrum=Spectral Density (m^2/Hz)
%
%         wave_spectra.type=String of the spectra type, i.e. Bretschneider, 
%         time series, date stamp etc. 
%
%         wave_spectra.frequency= frequency (Hz)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


py.importlib.import_module('mhkit');
py.importlib.import_module('numpy');

if (isa(frequency,'py.numpy.ndarray') ~= 1)
    frequency = py.numpy.array(frequency);
end

if strcmp(spectra_type,'pierson_moskowitz_spectrum')
    if nargin ==3
        S=py.mhkit.wave.resource.pierson_moskowitz_spectrum(frequency,Tp);
    else
        ME = MException('MATLAB:create_spectra','inncorrect number of arguments');
         throw(ME);
    end
    
elseif strcmp(spectra_type,'bretschneider_spectrum')
    if nargin ~= 4
         ME = MException('MATLAB:create_spectra','Hs is needed for bretschneider_spectrum');
         throw(ME);
    end
    S=py.mhkit.wave.resource.bretschneider_spectrum(frequency,Tp,varargin{1});

elseif strcmp(spectra_type,'jonswap_spectrum')
    if nargin < 4
         ME = MException('MATLAB:create_spectra','Hs is needed for jonswap_spectrum');
         throw(ME);
    elseif nargin == 4
        S=py.mhkit.wave.resource.jonswap_spectrum(frequency,Tp,varargin{1});
    elseif nargin == 5 
        S=py.mhkit.wave.resource.jonswap_spectrum(frequency,Tp,varargin{1},pyargs('gamma',varargin{2}));
    else
        ME = MException('MATLAB:create_spectra','to many input arguments');
         throw(ME);
    end

else 
    ME = MException('MATLAB:create_spectra','Not a Valid Spectrum Type');
    throw(ME);
end

wave_spectra.spectrum=double(py.array.array('d',py.numpy.nditer(S.values))).';
char_arr=char(S.index.values);
wave_spectra.type=spectra_type;
wave_spectra.frequency=double(py.array.array('d',py.numpy.nditer(S.index))).';
wave_spectra.Tp=Tp;
if nargin == 4 
    wave_spectra.Hs=varargin{1};
end



