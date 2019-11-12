function [equivalent_diameter,projected_capture_area]=multiple_circular(diameters)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Calculates the equivalent diameter and projected capture area of a 
%     multiple circular turbine
%     
%     Parameters
%     ------------
%     diameters: array or vector 
%         vector of device diameters [m]
%         
%     Returns
%     ---------
%     equivalent_diameter : float
%        Equivalent diameter [m]
%     projected_capture_area : float
%         Projected capture area [m^2]
%
%    Dependancies 
%    -------------
%    Python 3.5 or higher
%    mhkit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

py.importlib.import_module('mhkit');
diameters=py.list(diameters);
result=py.mhkit.river.device.multiple_circular(diameters);

resultc=cell(result);
equivalent_diameter=resultc{1};
projected_capture_area=resultc{2};