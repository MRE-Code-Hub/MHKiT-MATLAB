function figure=plot_flow_duration_curve(D,F,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots discharge vs exceedance probability as a Flow Duration Curve (FDC) 
%     
%     Parameters
%     ------------
%     D: array
%         Discharge [m/s] 
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

temp.D=D;
disp(D)
temp.F=F;
disp(F)
T=struct2table(temp);
sortT=sortrows(T,'F','descend');
disp(sortT)

figure=plot(sortT.D,sortT.F);
ylabel('Discharge [^m^{3}/_{s}]','FontSize',20)
xlabel('Exceedance Probability','FontSize',20)
set(gca,'XScale','log')

if nargin == 3
    title(varargin{1})
end