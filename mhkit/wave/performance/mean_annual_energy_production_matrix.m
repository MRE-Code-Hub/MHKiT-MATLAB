function maep=mean_annual_energy_production_matrix(LM,JM,frequency)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%    Calculates mean annual energy production (MAEP) from matrix data 
%     along with data frequency in each bin
%     
%     Parameters
%     ------------
%     LM: structure
%         Capture length
%     JM: structure
%         Wave energy flux
%     frequency: structure 
%         Data frequency for each bin. 
%         created by capture_length_matrix or Wave_energy_flux_matrix with
%         "count" option
%         
%     Returns
%     ---------
%     maep: float
%         Mean annual energy production
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[own_path,~,~] = fileparts(mfilename('fullpath'));
modpath= fullfile(own_path, '...');
P = py.sys.path;
if count(P,'modpath') == 0
    insert(P,int32(0),'modpath');
end

py.importlib.import_module('mhkit');

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

if (isa(frequency,'py.pandas.core.frame.DataFrame')~=1)
    x=size(frequency.values);
    li=py.list();
    if x(2)>1 
        for i = 1:x(2)
            app=py.list(frequency.values(:,i));
            li=py.pandas_dataframe.lis(li,app);
            
        end
    end
    freqpan=py.pandas_dataframe.timeseries_to_pandas(li,py.list(frequency.Hm0_bins),int32(x(2)));
end

maep=double(py.mhkit.wave.device.mean_annual_energy_production_matrix(LMpan,JMpan,freqpan));