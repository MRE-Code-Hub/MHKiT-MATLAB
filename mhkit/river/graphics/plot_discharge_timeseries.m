function figure=plot_discharge_timeseries(D,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Plots discharge vs time 
%     
% Parameters
% ------------
%     D: structure
%
%      D.Discharge=Discharge [m/s]
%
%      D.time= time
%         
%     title: string (optional)
%       title for the plot
% 
% Returns
% ---------
%     figure: Plot of discharge vs. time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure=plot(D.time,D.Discharge);
xlabel('Time','FontSize',20)
ylabel('Discharge [^m^{3}/_{s}]','FontSize',20)

if nargin ==2
    title(varargin{1})
end