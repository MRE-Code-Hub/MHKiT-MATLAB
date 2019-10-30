function poly=polynomial_fit(x,y,n)

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
%     poly: structure
%       coef: polynomial coefficients 
%       fit: fit coefficients 

[own_path,~,~] = fileparts(mfilename('fullpath'));
modpath= fullfile(own_path, '...');
P = py.sys.path;
if count(P,'modpath') == 0
    insert(P,int32(0),'modpath');
end

py.importlib.import_module('mhkit');
x=py.numpy.array(x);
y=py.numpy.array(y);
n=int32(n);

polyt=py.mhkit.river.resource.polynomial_fit(x,y,n);

polyc=cell(polyt);
coef=polyc{1};
fit=polyc{2};
poly.coef=double(py.array.array('d',py.numpy.nditer(coef.coef)));
poly.fit=fit;


