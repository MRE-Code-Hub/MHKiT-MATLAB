% Wrap QC functions around pecos monitoring check functions
% This all assumes a pandas dataframe with a datetime index
function results = qc_outlier(data,bound)
  results = struct(py.pecos.monitoring.check_outlier(data,bound))
end 
