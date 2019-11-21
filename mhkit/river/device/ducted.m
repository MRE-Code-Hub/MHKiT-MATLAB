function [equivalent_diameter,projected_capture_area]=ducted(diameter)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Calculates the equivalent diameter and projected capture area of a 
%     ducted turbine
%     
% Parameters
% ------------
%     diameter : float
%         ducted diameter [m]
%         
% Returns
% ---------
%     equivalent_diameter : float
%        Equivalent diameter [m]
%
%     projected_capture_area : float
%         Projected capture area [m^2]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

py.importlib.import_module('mhkit');

result=py.mhkit.river.device.ducted(diameter);

resultc=cell(result);
equivalent_diameter=resultc{1};
projected_capture_area=resultc{2};