function polynomial_coefficients=polynomial_fit(x,y,n)

% Returns a polynomial fit for y given x of order n.
% 
%     Parameters
%     ===========
%     x : array
%         x data for polynomial fit.
%     y : array
%         y data for polynomial fit.
%     n : int
%         order of the polynomial fit.
% 
%     Returns
%     ==========
%     polynomial_coefficients : list
%     list of polynomial coefficients

[own_path,~,~] = fileparts(mfilename('fullpath'));
modpath= fullfile(own_path, '...');
P = py.sys.path;
if count(P,'modpath') == 0
    insert(P,int32(0),'modpath');
end

py.importlib.import_module('mhkit');

polynomial_coefficients=py.mhkit.river.resource.polynomial_fit(x,y,n);