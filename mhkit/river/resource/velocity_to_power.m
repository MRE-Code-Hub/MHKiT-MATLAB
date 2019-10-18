function P=velocity_to_power(D,P,varagin)

% Calculates the power produced given resource discharge levels
%     and velocity data at an individual turbine location. Additionally will 
%     return polynomial fit to data as figure.
%     
%     TODO: Return polynomial fit, incorporate Kate's new assert functions,
%           Discuss how to document multiple options for API docs
% 
%     Parameters
%     ----------
%     D : DataFrame
%         Pandas DataFrame containing velocity for all discharge levels.
%     P : DataFrame
%         Pandas DataFrame with relation between velocity and power for turbine     
%     D_keys : list
%         Ordered list of length 1 of keys to use with DataFrame D in 
%         if the defaults 'v' are not used (e.g. ['vel']).
%     P_keys : ordered list
%         Ordered list of length 2 of keys to use with DataFrame P
%         in the order velocity, Power (e.g. ['vel', 'power']).
%     cut_in : string or float
%        'min'  - assumes the min velocity of 
%          the power curve to be the cut_in velocity. 
%        'None' - will calculate a power for resource
%          velocity ranges outside the polynomial fit.
%        float  - cut_in velocity may be speficied as a 
%          float value.
%     cut_out : string or float
%        'max'  - (default) assumes the max velocity of 
%          the power curve to be the cut_out velocity. 
%        'None' - will calculate a power for resource
%          velocity ranges outside the polynomial fit.
%        float  - cut_out velocity may be speficied as a 
%          float value.
%     order : int
%         order of the velocity to power polynomial fit 
%     plot_polynomial_fit : bool
%         Plots the polynomial fit and the P dataframe data
%     append : bool
%         Appends the output to the D DataFrame
% 
%     Returns   
%     -------
%     p : array or DataFrame
%         Uses polynomial fit to calculate power produced
%         for each V from the vdc curve within the specified
%         turbine operation velocity range.
% 
%     Examples
%     --------
%     >>> # Use USGS module to import 10 year daily discharge data
%     >>> data = river.io.usgs_data("15515500")
%     >>> df = river.io.usgs_data_to_df(data, data_key='discharge')
%     >>> # Convert to m3/s
%     >>> df.discharge = df.discharge / (3.28084)**3
%     >>> # Velocity data for VDC curve (1 turbine location), [discharge, velocity]
%     >>> vel_data = np.array( [ [515, 1.05], [575, 1.1], [645, 1.25],[850, 1.5], [1240, 1.8], [2917, 2.9]  ] )
%     >>> V = pd.DataFrame.from_records(vel_data, columns=['discharge', 'velocity'])
%     >>> # Use both dfs to append VDC data to FDC df 
%     >>> df = river.resource.discharge_to_velocity(df, V, append=True)
%     >>> # Calculate the energy produced
%     >>> power_data = np.array([[1.  , 0.18], [1.07, 0.23],[1.12, 0.23],[1.2 , 0.31],[1.26, 0.36],[1.36, 0.44],[1.4 , 0.47],[1.5 , 0.6 ],[1.6 , 0.74],[1.7 , 0.89],[1.8 , 1.07],[1.9 , 1.25],[2.  , 1.44],[2.1 , 1.72],[2.2 , 1.94],[2.3 , 2.24],[2.4 , 2.53],[2.51, 2.89],[2.6 , 3.28],[2.7 , 3.69],[2.8 , 4.13],[2.9 , 4.54],[3.  , 4.96]])
%     >>> # Make a dataframe from velocity data
%     >>> P = pd.DataFrame.from_records(power_data, columns=['velocity', 'power'])
%     >>> df = river.resource.velocity_to_power(df, P, P_keys=['vel','powerkW'], D_keys=['v','F'], order=2, plot_polynomial_fit=True, append=True)