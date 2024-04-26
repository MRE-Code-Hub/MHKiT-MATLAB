var sourceData50 = {"FileName":"/Users/asimms/Desktop/Programming/mhkit_matlab_simms_dev/MHKiT-MATLAB-2/mhkit/power/quality/calc_electrical_angle.m","RawFileContents":["function alpha_m = calc_electrical_angle(freq,alpha0)","","%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%","%   Calculates the electrical angle alpha_m(t) of the fundamental of the","% measured voltage (u_m(t)) according to IECTS 62600-30(ed1.0) Eq (3).","%","%","% Parameters","% -----------","%   alpha0: double","%       Electrical angle (radians) at t=0.","%   freq: struct()","%       .time: time at each measurement time step (s)","%       .data: double array of size (ntime), freq(t), the fundamental","%       frequency (that may vary over time) for u_m(t).","%","% Returns","% -------","%   alpha_m: double array (ntime)","%       Electrical angle (alpha_m(t)) of the fundamental component of u_m.","% Note","% -------","% 1. IECTS-62600-30 Eq(3):","%   alpha_m(t) = 2pi*integral(freq(t)dt)+alpha0","%","%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%","","    % check input:","    if ~isfield(freq,'time') || ~isfield(freq, 'data')","        ME = MException('MATLAB:calc_electrail_angle',...","            'invalid handles in structure, must contain x.data & x.time');","        throw(ME);","    end","","    % IECTS-62600-30 Eq(3)","    alpha_m = 2*pi*cumtrapz(freq.time,freq.data)+alpha0;","end","",""],"CoverageDisplayDataPerLine":{"Function":{"LineNumber":1,"Hits":2,"StartColumnNumbers":0,"EndColumnNumbers":53,"ContinuedLine":false},"Statement":[{"LineNumber":29,"Hits":2,"StartColumnNumbers":4,"EndColumnNumbers":54,"ContinuedLine":false},{"LineNumber":30,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":53,"ContinuedLine":false},{"LineNumber":31,"Hits":0,"StartColumnNumbers":12,"EndColumnNumbers":74,"ContinuedLine":true},{"LineNumber":32,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":18,"ContinuedLine":false},{"LineNumber":36,"Hits":2,"StartColumnNumbers":4,"EndColumnNumbers":56,"ContinuedLine":false}]}}