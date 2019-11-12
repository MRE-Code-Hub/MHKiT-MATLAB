function poly=polynomial_fit(x,y,n)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%
%    Dependancies 
%    -------------
%    Python 3.5 or higher
%    mhkit
%    numpy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


