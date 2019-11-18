.. _wave:

Wave module
========================================

The :class:`~mhkit.wave` module contains a set of functions to
calculate quantities of interest for wave energy converters (WEC). 
The wave module contains the following submodules:

* :class:`~mhkit.wave.io`: Loads data from standard formats
* :class:`~mhkit.wave.resource`: Computes resource metrics such as spectra and significant wave height
* :class:`~mhkit.wave.performance`: Computes performance metrics such as capture length matrix and mean annual energy production
* :class:`~mhkit.wave.graphics`: Generates graphics

Data formats and IO
--------------------

As with other modules in the MHKiT Matlab package, the MHKit Python modules are used 
within the wave module.  The wave module uses wave elevation and spectra data.

* **Wave elevation data** is time-series data stored as an array which is converted to a pandas DataFrame with a time index.  The column names describe the type of data in each column.

* **Spectra data** can be stored in a structure with frequency, type, and spectrum field names or converted to a pandas DataFrame where the index is a `descriptor` and columns are
  frequency.  The descriptor(type)/frequency can be time (in seconds or a DateTime index), or some other information that
  defines each row of the spectra data.  For example, if spectra data is computed using the JONSWAP method,
  the index or type is a string that includes the significant wave height and peak period used to compute the
  spectra in each row.

* **Directional spectra data** is stored in a ... 



Wave resource
--------------------------------------

The wave resource submodule contains methods to wave energy spectra and various metrics from the spectra.

The following options exist to compute wave energy spectra:

.. autosummary::

   ~elevation_spectrum.m
   ~create_spectra.m
   

The following metrics can be computed from the spectra:

.. autosummary::

   ~frequency_moment.m
   ~significant_wave_height.m
   ~average_zero_crossing_period.m
   ~average_crest_period.m
   ~average_wave_period.m
   ~peak_period.m
   ~energy_period.m
   ~spectral_bandwidth.m
   ~spectral_width.m
   ~energy_flux.m
   ~wave_celerity.m
   ~wave_number.m
                              


Device performance
---------------------

The device submodule contains methods to compute power performance and quality, watch circle, loads? ...

The following methods are available:

* **Capture length**
* **Mean annual energy production**: 2 methods in 1 function
* **Power matrix**
* **Binned matrix**:  bins data, input = X, Y, Z (i.e Hs, Tp, capture length), and stat.  The function uses stats on the capture length and produces a matrix

Motion

* **Response amplitude operator**: if we have time
* **Watch circle**: if we have time

Graphics
-----------

The graphics submodule contains methods to plot wave data and related metrics.  The data types used in mhkit are compatible with many Python packages to create custom graphics (matplotlib, pandas, seaborn).  The graphics submodule includes the following methods:

.. autosummary::

   ~plot_spectrum.m
   
* **Heatmap**: used to plot the binned matrix
* **Scatter plot**: also used to plot binned matrix
