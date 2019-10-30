function datast=read_usgs_file(file_name)

%     Reads a USGS JSON data file (from https://waterdata.usgs.gov/nwis) 
%     into a structure 
% 
%     Parameters
%     ----------
%     file_name : str
%         Name of USGS JSON data file
%         
%     Returns
%     -------
%     data : structure  
%         Data:named according to the parameter's variable description
%         time: datetime
%         units: units for each parameter

[own_path,~,~] = fileparts(mfilename('fullpath'));
modpath= fullfile(own_path, '...');
P = py.sys.path;
if count(P,'modpath') == 0
    insert(P,int32(0),'modpath');
end

py.importlib.import_module('mhkit');

datapd=py.mhkit.river.io.read_usgs_file(file_name);
disp(datapd)

xx=cell(datapd.axes);
v=xx{2};


vv=cell(py.list(py.numpy.nditer(v.values,pyargs("flags",{"refs_ok"}))));

vals=double(py.array.array('d',py.numpy.nditer(datapd.values)));
sha=cell(datapd.values.shape);
x=int64(sha{1,1});
y=int64(sha{1,2});

vals=reshape(vals,[x,y]);
ti=cell(py.list(py.numpy.nditer(datapd.index)));
siti=size(ti);
si=size(vals);
 for i=1:si(2)
    test=string(py.str(vv{i}));
    newname=split(test,",");
    
    datast.(newname(1))=vals(:,i);
    datast.units.(newname(1))=newname(2);
 end
 for i=1:siti(2)
    datast.time{i}=datetime(string(py.str(ti{i})),'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSSSSSSSS');
 end



