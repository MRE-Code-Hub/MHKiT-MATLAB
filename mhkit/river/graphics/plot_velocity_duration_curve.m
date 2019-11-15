function figure=plot_velocity_duration_curve(V,F,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots velocity vs exceedance probability as a Flow Duration Curve (FDC) 
%     
%     Parameters
%     ------------
%     V: array
%         Velocity [m/s] 
%         
%     F: array 
%          Exceedance probability [unitless]
%
%   Optional
%  ----------
%  title: string
%       title for the plot
% 
%   Returns
%   ---------
%   figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

temp.V=V;

temp.F=F;

T=struct2table(temp);
sortT=sortrows(T,'F','descend');


figure=plot(sortT.V,sortT.F);
ylabel('Velocity [^m^{3}/_{s}]','FontSize',20)
xlabel('Exceedance Probability','FontSize',20)


if nargin == 3
    title(varargin{1})
end