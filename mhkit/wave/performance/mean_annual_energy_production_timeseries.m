function maep=mean_annual_energy_production_timeseries(L,J)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  Calculates mean annual energy production (MAEP) from timeseries
%     
%     Parameters
%     ------------
%     L: numpy array or vector
%         Capture length
%     J: numpy array or vector
%         Wave energy flux
%         
%     Returns
%     ---------
%     maep: float
%         Mean annual energy production
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[own_path,~,~] = fileparts(mfilename('fullpath'));
modpath= fullfile(own_path, '...');
P = py.sys.path;
if count(P,'modpath') == 0
    insert(P,int32(0),'modpath');
end

py.importlib.import_module('mhkit');

J=py.numpy.array(J);
L=py.numpy.array(L);

maep=double(py.mhkit.wave.device.mean_annual_energy_production_timeseries(L,J));
