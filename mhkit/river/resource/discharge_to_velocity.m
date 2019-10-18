function D=discharge_to_velocity(D,V,varargin)

% Calculates the velocity v given resource 
%     discharge levels (DataFrame D) and velocity data at an individual
%     turbine location for varying river discharge levels (DataFrame V).
%     Typically velocity DataFrame contains 15 points of velocity to 
%     discharge relations. Additionally this function will return the 
%     polynomial fit to velocity DataFrame.
%     
%     Parameters
%     ------------
%     D : DataFrame
%        Pandas DataFrame with 10 years of daily discharge [m3/s] values 
%        specified by either the key 'discharge' or D_keys.
%     V : DataFrame 
%        Pandas DataFrame relating discharge [m3/s] and velocity [m/s] at
%        turbine location      
%     D_keys : list
%         If DataFrame D uses key that is not 'discharge' can specify what
%         key to use for discharge. List must be of length 1.
%     V_keys : ordered list
%         If DataFrame V uses key that is not 'discharge' and 'velocity' 
%         the user can specify what key to use in this ordered list 
%         where the first position is the discharge key and the second 
%         value is the velocity key (e.g. ['dis','vel']). List must be 
%         of length 2. 
%     order : integer
%         Order of the polynomial fit
%     plot_polynomial_fit : bool
%         returns plot of polynomial fit to data in V
%     append : bool
%         Returns DataFrame with only 'v'. If True returns DataFrame
%         D with 'v' appended in the DataFrame.
% 
%     Returns   
%     ------------
%     v: array-like 
%        Uses polynomial fit from data in V to calculate velocity for
%        each discharge in D. If append is True then 'v' is appended 
%        to DataFrame D.
% 
%     Examples
%     --------
%     >>> # Use USGS module to import 10 year daily discharge data
%     >>> data = river.io.usgs_data("15515500")
%     >>> df = river.io.usgs_data_to_df(data, data_key='discharge')
%     >>> # Convert to m3/s
%     >>> df.discharge = df.discharge / (3.28084)**3
%     >>> # Calculate the exceedance probability f. and append to df
%     >>> df = river.resource.exceedance_probability(df, append=True)
%     >>> # Velocity data for VDC curve (1 turbine location), [discharge, velocity]
%     >>> vel_data = np.array( [ [515, 1.05], [575, 1.1], [645, 1.25],[850, 1.5], [1240, 1.8], [2917, 2.9]  ] )
%     >>> V = pd.DataFrame.from_records(vel_data, columns=['discharge', 'velocity'])
%     >>> # Use both dfs to append VDC data to FDC df 
%     >>> df = river.resource.discharge_to_velocity(df, V, append=True)
