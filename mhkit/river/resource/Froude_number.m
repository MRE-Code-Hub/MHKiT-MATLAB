function Fr=Froude_number(v,h,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Calculate the Froude Number of the river, channel or duct flow,
%     to check subcritical flow assumption (if Fr <1).
%     
%     Parameters
%     ------------
%     v : float 
%         Average Velocity [m/s].
%     h : float
%         Mean hydrolic depth float [m].
%     Optional
%     g : float
%         gravitational acceleration [m/s2].
% 
%     Returns
%     ---------
%     Fr : float
%         Froude Number of the river [unitless].
% 
%   
%    Dependancies 
%    -------------
%    Python 3.5 or higher
%    mhkit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

py.importlib.import_module('mhkit');

if nargin == 3 
     g=varagin{1};
     Fr=py.mhkit.river.resource.Froude_number(v,h,pyargs('g',g));
else 
     Fr=py.mhkit.river.resource.Froude_number(v,h);
end
