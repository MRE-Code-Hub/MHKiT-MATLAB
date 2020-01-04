% Examples of how to use matlab qc functions, and their pecos/python equivalents,
% from matlab.

pecos = py.importlib.import_module('pecos');
pd = py.importlib.import_module('pandas');
mhkit = py.importlib.import_module('mhkit');

% Load data using Pandas, you can probably do this in Matlab as well
% Hardcoded path to mhkit-python dist
data = py.pandas.read_csv('../../examples/data/qc_example_data.csv');
data = data.set_index('Time');

% Convert index to datetime (Pecos also includes a method to convert back
% to epoch time)
data.index = py.pecos.utils.index_to_datetime(data.index,'s','2019-05-20');

% Now generate matlab qc data structure

qcdata.values = double(data.values);

% Convert index to posix time arrayfrom py.numpy.ndarray format
% Apparently, numpy uses nanoseconds since 19700101 0000Z internally, so
% posix time is that divided by 1e9
ptime = double(py.array.array('d',py.numpy.nditer(data.index.values)))/1e9;

% Now convert to matlab datetime format
qcdata.time = datetime(ptime,'ConvertFrom','posix');

% Run some matlab qc functions

% Important - Run q1 first, to reorder to monotonic if any data out of line
% Feed results of each into next test, as you need timestamp fixing and 
% corrupt and missing data eliminated or it might mess up the later tests
% (especially delta, which looks for a range
q1=qc_timestamp(qcdata,.002);
q2=qc_missing(q1);
q3=qc_corrupt(q2,{-999.}); % or q4=qc_corrupt(qcdata,[-999.,NaN]) 
q4=qc_range(q3,[-50,50]);

q5=qc_outlier(q4,[0,2]);
q6=qc_delta(q5,[0,40],py.None,.006);
q7=qc_increment(q6,[0,30]);

% Do the same thing as above, only working with python dataframe (data)
% and calling pecos functions directly.

%% QC using Pecos functions (results contains cleaned_data, mask, and test_results)
r1 = struct(py.pecos.monitoring.check_timestamp(data,0.002));
r2 = struct(py.pecos.monitoring.check_missing(r1.cleaned_data));
r3 = struct(py.pecos.monitoring.check_corrupt(r2.cleaned_data,[-999.]));
r4 = struct(py.pecos.monitoring.check_range(r3.cleaned_data,[-50,50]));

r5 = struct(py.pecos.monitoring.check_outlier(r4.cleaned_data,[0,2]));
r6 = struct(py.pecos.monitoring.check_delta(r5.cleaned_data,[0,40],py.None, .006));
r7 = struct(py.pecos.monitoring.check_increment(r6.cleaned_data,[0,30]));

% Extract results (still python dataframes)
r7.cleaned_data
r7.mask
r7.test_results

% Compare with matlab functions - should be 0s across the three columns
max(abs(q7.values - double(r7.cleaned_data.values)))

%% QC using Pecos PerformanceMonitoring object
pm = py.pecos.monitoring.PerformanceMonitoring();
pm.add_dataframe(data)
pm.check_timestamp(0.002)
pm.check_missing()
pm.check_range([-50,50])

% Extract results
pm.cleaned_data
pm.mask
pm.test_results

