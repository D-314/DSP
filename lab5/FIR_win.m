clear all;

       N  = 17;
       w1  = rectwin(N);
       w2 = chebwin(N,60);
       w3 = kaiser(N,2);
       w4  = hamming(N);
       w5  = hann(N);
       w6  = triang(N);
       plot(1:N,[w1,w2,w3,w4,w5,w6]); 
       axis([0 N+1 0 1.5]);
       legend('Rectangle','Chebyshev','Kaiser','Hamming','Hann','Triangle');
       wvtool(w4)
       
% Leakage factor--ratio of power in the sidelobes to the total window power
% Relative sidelobe attenuation--difference in height from the mainlobe peak to the highest sidelobe peak
% Mainlobe width (-3dB)--width of the mainlobe at 3 dB below the mainlobe peak

