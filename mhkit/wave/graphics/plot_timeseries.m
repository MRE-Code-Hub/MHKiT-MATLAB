function figure=plot_timeseries(time,eta)

% """
%     Plots wave amplitude time-series
%     
%     Parameters
%     ------------
%     time: array float/int (s)
%     eta: array or float/int 
%        wave surface elevation (m)
%         
%     Returns
%     ---------
%     figure: figure
%         Plot of wave surface elevation vs. time
%     
%     """
figure=plot(time,eta);
xlabel('Time (s)')
ylabel('Eta (m)') 
title('Wave Surface Elevation')
