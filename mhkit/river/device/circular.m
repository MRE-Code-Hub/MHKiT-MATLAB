function [equivalent_diameter,projected_capture_area]=circular(diameter)
 
%     Calculates the equivalent diameter and projected capture area of a 
%     circular turbine
%     
%     Parameters
%     ------------
%     diameter : float
%         Turbine diameter [m]
%         
%     Returns
%     ---------
%     equivalent_diameter : float
%        Equivalent diameter [m]
%     projected_capture_area : float
%         Projected capture area [m^2]

[own_path,~,~] = fileparts(mfilename('fullpath'));
modpath= fullfile(own_path, '...');
P = py.sys.path;
if count(P,'modpath') == 0
    insert(P,int32(0),'modpath');
end

py.importlib.import_module('mhkit');

result=py.mhkit.river.device.circular(diameter);

resultc=cell(result);
equivalent_diameter=resultc{1};
projected_capture_area=resultc{2};