function p=velocity_to_power(V,polynomial_coefficients,cut_in,cut_out)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates power given velocity data and the relationship 
%     between velocity and power from an individual turbine
%     
%     Parameters
%     ----------
%     V : pandas dataframe or structure
%         Velocity [m/s] indexed by time [s]
%     polynomial_coefficients : numpy polynomial
%         List of polynomial coefficients that discribe the relationship between 
%         velocity and power at an individual turbine
%     cut_in: float
%         Velocity values below cut_in are not used to compute P
%     cut_out: float
%         Velocity values above cut_out are not used to compute P
%     
%     Returns   
%     -------
%     p : Structure 
%        P: Power [W] 
%        time: epoch time [s]
%
%    Dependancies 
%    -------------
%    Python 3.5 or higher
%    Pandas
%    mhkit_python_utils
%    numpy
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


py.importlib.import_module('mhkit_python_utils');
py.importlib.import_module('mhkit');

if (isa(V,'py.pandas.core.frame.DataFrame')~=1)
    x=size(V.V);
    li=py.list();
    if x(2)>1 
        for i = 1:x(2)
            app=py.list(V.V(:,i));
            li=py.mhkit_python_utils.pandas_dataframe.lis(li,app);
            
        end
    elseif x(2) ==1 
        li=V.V;
    end


    V=py.mhkit_python_utils.pandas_dataframe.timeseries_to_pandas(li,V.time,int32(x(2)));
end

polynomial_coefficients=py.numpy.poly1d(polynomial_coefficients);
cut_in=py.float(cut_in);
cut_out=py.float(cut_out);
Pdf=py.mhkit.river.resource.velocity_to_power(V,polynomial_coefficients,cut_in,cut_out);
disp(Pdf)


xx=cell(Pdf.axes);
v=xx{2};
vv=cell(py.list(py.numpy.nditer(v.values,pyargs("flags",{"refs_ok"}))));

vals=double(py.array.array('d',py.numpy.nditer(Pdf.values)));
sha=cell(Pdf.values.shape);
x=int64(sha{1,1});
y=int64(sha{1,2});

vals=reshape(vals,[x,y]);

si=size(vals);
 for i=1:si(2)
    test=string(py.str(vv{i}));
    newname=split(test,",");
    disp(newname)
    p.(newname(1))=vals(:,i);
    
 end
 p.time=double(py.array.array('d',py.numpy.nditer(Pdf.index)));
