function L=capture_length(Power,J)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%    
%    Calculates the capture length (often called capture width).
% 
%     Parameters
%     ------------
%     P: numpy array or vector
%         Power [W]
%     J: numpy array or vector
%         Omnidirectional wave energy flux [W/m]
%     
%     Returns
%     ---------
%     L: vector
%         Capture length [m]
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

Power=py.numpy.array(Power);
J=py.numpy.array(J);


L=double(py.mhkit.wave.device.capture_length(Power,J));
