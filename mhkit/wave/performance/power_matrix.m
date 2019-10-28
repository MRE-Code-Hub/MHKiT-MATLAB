function PM=power_matrix(LM,JM)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  Generates a power matrix from a capture length matrix and wave energy 
%     flux matrix
% 
%     Parameters
%     ------------
%     LM: structure
%         LM.values: Capture length matrix
%         LM.Hm0_bins
%         LM.Te_bins
%     JM: structure
%         JM.values: Wave energy flux matrix
%         JM.Hm0_bins
%         JM.Te_bins
%         
%     Returns
%     ---------
%     PM: Structure
%         Power matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[own_path,~,~] = fileparts(mfilename('fullpath'));
modpath= fullfile(own_path, '...');
P = py.sys.path;
if count(P,'modpath') == 0
    insert(P,int32(0),'modpath');
end

py.importlib.import_module('mhkit');

% need to add asserts for pandas
if (isa(LM,'py.pandas.core.frame.DataFrame')~=1)
    x=size(LM.values);

    li=py.list();
    if x(2)>1 
        for i = 1:x(2)
            app=py.list(LM.values(:,i));
            li=py.pandas_dataframe.lis(li,app);
            
        end
    end

    LMpan=py.pandas_dataframe.timeseries_to_pandas(li,py.list(LM.Hm0_bins),int32(x(2)));
    
end

if (isa(JM,'py.pandas.core.frame.DataFrame')~=1)
    x=size(JM.values);
    li=py.list();
    if x(2)>1 
        for i = 1:x(2)
            app=py.list(JM.values(:,i));
            li=py.pandas_dataframe.lis(li,app);
            
        end
    end
    JMpan=py.pandas_dataframe.timeseries_to_pandas(li,py.list(JM.Hm0_bins),int32(x(2)));
end

PMpan=py.mhkit.wave.device.power_matrix(LMpan,JMpan);

vals=double(py.array.array('d',py.numpy.nditer(PMpan.values)));
sha=cell(PMpan.values.shape);
x=int64(sha{1,1});
y=int64(sha{1,2});
vals=reshape(vals,[y,x]);
vals=transpose(vals);

PM.values=vals;
PM.stat=LM.stat;
PM.Hm0_bins=double(LM.Hm0_bins);
PM.Te_bins=double(LM.Te_bins);