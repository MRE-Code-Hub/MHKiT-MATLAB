function k=wave_number(f,h,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%    
%    Parameters
%    ------------
%    f: frequency (Hz)
%           vector or numpy array
%    h: float
%         Water depth (m)
%
%     Optional 
%     ---------
%     NOTE: In matlab, if you set one optional parapeter, you must set
%     both, rho first, then g
%     rho: float
%         water density (kg/m^3)
%     g: float
%         gravitational acceleration (m/s^2)
%         
%
%     Returns
%     -------
%     k: structure
%         k.values: wave number
%         k.frequency: frequency [Hz]
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

%f=py.numpy.array(double(f));

if nargin == 4 
    kdf=py.mhkit.wave.resource.wave_number(f,h,pyargs('rho',varargin{1},'g',varargin{2}));
elseif nargin == 2
    kdf=py.mhkit.wave.resource.wave_number(f,h);
    disp(kdf)
else
    ME = MException('MATLAB:wave_number','incorrect numner of arguments');
        throw(ME);
end


k.values=double(py.array.array('d',py.numpy.nditer(kdf.values)));
k.frequency=double(py.array.array('d',py.numpy.nditer(kdf.index)));
k.h=h;
