function EP=exceedance_probability(D,varagin)

% Calculates the exceedance probability 'f'. Returns for 10 years of
%     daily discharge data.
%     
%     Parameters
%     ----------
%     D : DataFrame 
%         Pandas DataFrame with Index of type DateTimeIndex and column
%         of discharge.
%     Optional
%     key : string
%         Optional parameter for use when passing a dataframe with
%         multiple parameters to specify the column to sort and calculate
%         on.
%     force_daily_index : bool
%         FDC calculation requires 10 years of daily data. If you want
%         to bypass the daily data requirement set to False.
%     append : bool
%         Changes the function return. If False the exceedence probability
%         'f' is returned. If True a new DataFrame is returned sorted by 
%         exceedence probability with F appended in the DataFrame.
%         
% 
%     Returns   
%     -------
%     f: array or DataFrame 
%         Exceedance probability [unitless]. If append=True the original
%         dataframe is returned with F appended to it but sorted by f.
% 
%     Examples
%     --------
%     >>> # Use USGS module to import 10 year daily discharge data
%     >>> data = river.io.usgs_data("15515500")
%     >>> df = river.io.usgs_data_to_df(data, data_key='discharge')
%     >>> # Convert to m3/s
%     >>> df.discharge = df.discharge / (3.28084)**3
%     >>> # Calculate the exceedence probability f. and append to df
%     >>> df = river.resource.exceedance_probability(df, append=True)