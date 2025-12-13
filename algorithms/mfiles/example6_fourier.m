% 
% example 6
% Fourier Transform
%
% Amir Monadjemi, 2015

% house keeping
clear all
close all
clc
% getting the image file name, it is a gray level image
fnam = 'IMG_0295_crop1_gl.jpg' ;
b = imread(fnam) ;
% figure 1 shows the image
figure(1) ;
imshow(b) , title('original image') ;
b = double(b) ;
[mm,nn] = size(b) ;
% fft2 function is employed to compute the 2d fft matrix, fb, which is
% double and complex of size mmxnn
fb = fft2(b) ;
% in Figure 2, we show the FFT domain or power spectural density, its log
% scale plot, and vertical plot of both.
% abs function, employed on complex variables, compute the absolute valuse
% or the domain, for signals it means their PSd r power spectral density.
% fftshift function swaps the quarters of the fft matrix to brng the lowest
% frequencies into the middle of the frequency plan.
% flipud function flips the rows of the matrix, first row becomes last, and
% the last row becomes first. to keep the view compatible with other plots
figure(2)
subplot(2,2,1), mesh( fftshift(abs(flipud(fb)))) , title('FFT Absolute or Pwer Spectral Density') , colorbar , colormap(hot) ;
subplot(2,2,2), mesh( log( 1+ fftshift(abs(flipud(fb)))) ), title('FFT Absolute or Pwer Spectral Density , log scale') , colorbar , colormap(hot) ;
subplot(2,2,3), mesh( fftshift(abs(flipud(fb)))) , title('FFT Absolute or Pwer Spectral Density') , colorbar , colormap(hot) , view(2);
subplot(2,2,4), mesh( log( 1+ fftshift(abs(flipud(fb)))) ), title('FFT Absolute or Pwer Spectral Density , log scale') , colorbar , colormap(hot) , view(2);

% inf igure 3 we show the angle or phase of the image in fourier or 
% frequency domain. angle function provides the fourier phase. unwrap
% function transfer the radian phase angles by adding multiples of ±2? when
% absolute jumps between consecutive elements greater than
% or equal to the default jump tolerance of ? radians. 
%
figure(3);
subplot(1,2,1), mesh( fftshift(angle(flipud(fb)))) , title('FFT Phase') , colorbar , colormap(hot) ;
subplot(1,2,2), mesh( fftshift(unwrap(angle(flipud(fb))))) , title('FFT Phase unwrapped') , colorbar , colormap(hot) ;
%
% we emplys a butterworth lowpass frequency domain filter
ff = butter_filt2(mm,nn,nn/4,2) ;
% then build a highpass filter based on it and show that in figure 4.
ff = 1 - ff ;
figure(4);
mesh(ff) , colorbar , colormap(hot), title('butterworth highpass filter, cutoff=pi/2') ;
%
% using my_ff_filt2p function, the image is highpass filtered and inverse
% transformed back to the spatial domain. xb is the result
% fb is the image fft, and ff is the filter matrix
xb = my_ff_filt2p(fb,ff) ;
xb = abs(real(xb)) ;
%
% now we show the filtered image and its thresholded version in figures 5
% and 6
figure(5)
mesh(flipud(xb)) , view(2) , colorbar , title('highpass filtered') ;
figure(6)
imshow(uint8( (xb>=3.5) .*240 )) , title('highpass filtered, binary')

%  C U later ....
return