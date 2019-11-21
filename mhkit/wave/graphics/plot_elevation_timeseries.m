function figure=plot_elevation_timeseries()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Plots wave elevation timeseries
%     
% Input
% ------------
%     wave_elevation: Structure of the following form:
%
%         wave_elevation.elevation=elevation [m]
%
%         wave_elevation.time= time (s);
%         
% Returns
% ---------
%     figure: figure
%         Plot of wave elevation vs. time
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure=plot(wave_elevation.time,wave_elevation.elevation);
xlabel('Time (s)')
ylabel('Wave Elevation (m)') 

