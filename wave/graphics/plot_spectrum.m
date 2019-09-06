function figure=plot_spectrum(wave_spectra)

% """
%     Plots wave amplitude spectrum
%     
%     Parameters
%     ------------
%     wave_spectra: Structure of the following form:
%         wave_spectra.spectrum=Spectral Density (m^2-s;
%         wave_spectra.type=String of the spectra type, i.e. Bretschneider, 
%                time series, date stamp etc. ;
%         wave_spectra.frequency= frequency (Hz);
%         
%     Returns
%     ---------
%     figure: matplotlib pyplot figure
%         Plot of wave amplitude spectra versus omega
%     
%     """

