function figure=plot_discharge_vs_velocity(D,V,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Plots discharge vs velocity 
%     
% Parameters
% ------------
%     D: array
%         Discharge [m/s]
%
%     V: array
%         Velocity [m/s] 
%
%     title: string (optional)
%         title for the plot
%
%   polynomial_coeff: array (optional)
%       polynomial coefficients which can be computed from 
%       polynomial_fit.m. Expects poly.coef
% 
% Returns
% ---------
%   figure: plot of discharge vs. velocity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure=plot(D,V);
xlabel('Discharge [^m^{3}/_{s}]','FontSize',20)
ylabel('Velocity [^m^{3}/_{s}]','FontSize',20)

if nargin == 3
    if isstring(varargin{1})
        title(varargin{1})
    elseif isnumeric(varargin{1})
        x=linspace(min(D),max(D),size(varargin{1}));
        hold on
        plot(x,varargin{1})
    else
        ME = MException('MATLAB:plot_discharge_vs_velocity','Variable argument is of the wrong type');
        throw(ME);
    end
    
elseif nargin ==4 
    if isstring(varargin{1}) & isnumeric(varargin{2})
        
        si=size(varargin{2});
        x=linspace(min(D),max(D),si(2));
        hold on
        plot(x,varargin{2})
        title(varargin{1})
    elseif isstring(varargin{2}) & isnumeric(varargin{1})
        si=size(varargin{1});
        x=linspace(min(D),max(D),si(2));
        hold on
        plot(x,varargin{1})
        title(varargin{2})
    else
        ME = MException('MATLAB:plot_discharge_vs_velocity','Variable argument is of the wrong type');
        throw(ME);
    end
elseif nargin > 4
    ME = MException('MATLAB:plot_discharge_vs_velocity','Too many arguments given');
        throw(ME);
end
        
hold off        
        
