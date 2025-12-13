% Example 4 - unsharp masking
%
% amir monadjemi - 2015
%
%

% house keeping
clear all
close all
clc
% reading the file neame, loading the image into a, conversion to double
% and gray scale
fnam = input('enter the image file name: ' , 's') ;
a = imread(fnam) ;
a= double(a) ;
[M,N,P] = size(a) ;
if (P==3)
  a = a(:,:,1)*0.3 + a(:,:,2)*0.6 + a(:,:,3)*0.1 ;
endif

% definition of the low pass filter in h, it's a 4x4 simple averager
h = ones(4,4) ./ 16 ;
% using convolution to apply it, result in b, keep the sizes the same
b = conv2(a,h,'same') ;
% absolute difference with the original image
a = abs(a-b) ;
% the outcome is shown in negative form
figure(1) ;
imshow(uint8(255-a)) , title(['unsharp masking -',fnam, ' - NEGATIVE']) ;
% and after histogram equalization
figure(2) ;
imshow(histeq(uint8(a))) , title(['unsharp masking -',fnam, ' - HIST EQ']) ;
% we plot the histogram of the result
h = imhist(uint8(a)) ;
figure(3) ;
plot(h,'r+'), title('abs unsharp histogram') ;
% and ask for the binarization threshold
thr =input('threshold for binarization? ') ;
mx = max(max(a)) ;
a = (a >= mx*thr) ;
a= uint8(a) .* 255 ;
% the final figure is the binary thresholded unsharp masked image
figure(4) ;
imshow(a) , title(['unsharp masking -',fnam, ' - THRESHOLDED/BINARY']) ;

return