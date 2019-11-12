function figure=plot_matrix(M,Mtype)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Plots the matrix with Hm0 and Te on the y and x axis
%
%    Input
%    -------
%    M: structure
%         M.values: matrix
%         M.Hm0_bins
%         M.Te_bins
%         M.stat
%    Mtype: string
%         type of matrix (i.e. power, caplture length, etc.) will be used
%         in plot title 
%
%   Returns
%   ---------
%   figure: plot of the matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure=pcolor(M.Te_bins,M.Hm0_bins,M.values);
colormap(flipud(hot))
ylabel('Hm0 [m]','FontSize',20)
xlabel('Te [s]','FontSize',20)
x=strcat(Mtype,': ',M.stat);
title(x)
colorbar