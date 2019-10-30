function EP=exceedance_probability(D)

% Calculates the exceedance probability
    
%     Parameters
%     ----------
%     D : pandas DataFrame  
%               Discharge data [m^3/s] indexed by time [datetime].  Note that 
%               river resource calculations require 10 years of daily data.
%         or Structure
%               D.Discharge
%               D.time in epoch time(s)
%         
%     Returns   
%     -------
%     EP : Structure     
%         Exceedance probability [unitless] indexed by time [epoch time (s)]

[own_path,~,~] = fileparts(mfilename('fullpath'));
modpath= fullfile(own_path, '...');
P = py.sys.path;
if count(P,'modpath') == 0
    insert(P,int32(0),'modpath');
end

py.importlib.import_module('mhkit');

if (isa(D,'py.pandas.core.frame.DataFrame')~=1)
    x=size(D.Discharge);
    li=py.list();
    if x(2)>1 
        for i = 1:x(2)
            app=py.list(D.Discharge(:,i));
            li=py.pandas_dataframe.lis(li,app);
            
        end
    elseif x(2) ==1 
        li=D.Discharge;
    end
    
    if any(isdatetime(D.time{1}))
        si=size(D.time);
        for i=1:si(2)
        D.time{i}=posixtime(D.time{i});
        end
    end
    D=py.pandas_dataframe.timeseries_to_pandas(li,D.time,int32(x(2)));
end

EPpd=py.mhkit.river.resource.exceedance_probability(D);

xx=cell(EPpd.axes);
v=xx{2};
vv=cell(py.list(py.numpy.nditer(v.values,pyargs("flags",{"refs_ok"}))));

vals=double(py.array.array('d',py.numpy.nditer(EPpd.values)));
sha=cell(EPpd.values.shape);
x=int64(sha{1,1});
y=int64(sha{1,2});

vals=reshape(vals,[x,y]);

si=size(vals);
 for i=1:si(2)
    test=string(py.str(vv{i}));
    newname=split(test,",");
    
    EP.(newname(1))=vals(:,i);
    
 end
 EP.time=double(py.array.array('d',py.numpy.nditer(EPpd.index)));




