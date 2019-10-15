%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Testing/demo program for wave.resource 
%
% Created on October 15, 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





Tp = 8;
Hs = 2.5;

omega = linspace(0.1,3.5,0.01);
f = omega/(2*pi);

BS=create_spectra('bretschneider_spectrum',f,Tp,Hs);
m0=frequency_moment(BS,0);
Hmo=significant_wave_height(BS);
Tp0=peak_period(BS);
figure=plot_spectrum(BS);