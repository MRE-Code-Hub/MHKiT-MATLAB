function Fr=Froude_number(v,h,varargin)
%
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
[own_path,~,~] = fileparts(mfilename('fullpath'));
modpath= fullfile(own_path, '...');
P = py.sys.path;
if count(P,'modpath') == 0
    insert(P,int32(0),'modpath');
end

py.importlib.import_module('mhkit');

if nargin == 3 
     g=varagin{1};
     Fr=mhkit.river.resource.Froude_number(v,h,pyargs('g',g));
else 
     Fr=mhkit.river.resource.Froude_number(v,h);
