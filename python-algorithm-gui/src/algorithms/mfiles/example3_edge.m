% example 3
% edge detection using local operations
% spatial domain Sobel filters areused for edge/line detection
%
% amir monadjemi - 2015
%
% house keeping again 
clear all
close all
clc
% a binarization threshold is set to 0.1.
% it will be detailed later
tr = 0.1;
% getting theimage file name and loading the file into matrix a
fnam = input('enter the image file name: ' , 's') ;
a = imread(fnam) ;
% converting a to double and gray scale
a= double(a) ;
a = a(:,:,1)*0.3 + a(:,:,2)*0.6 + a(:,:,3)*0.1 ;
% we build up a 24 bit image where all color channels are similar to
% show a clearer gray scale image in Figure 1, Line 26
for i=1:3
    b(:,:,i) = a ;
end
figure(1);
subplot(2,2,1) , imshow(uint8(b)) , title(['a) original GL image  ' , fnam]) ;
%
% building up the Sobel filter matrices, hy is for vertical lines/edges
% detection, and hx for horizontal. 
hy = [ 1  0 -1; 2  0 -2; 1  0 -1]
hx = [ 1  2  1; 0  0  0; -1 -2 -1]
%
% 2d convolution for applying filters and building the edge strength matrix
% in a
ax = conv2(a,hx,'valid') ;
ay = conv2(a,hy,'valid') ;
a = ( ax .^ 2 + ay .^ 2) .^0.5 ;
%
% results are illustrrated. flipud function is used for bringing the
% horizontal axis up, just like imshow
subplot(2,2,2) , mesh(flipud(ax)) , view(2), colormap(summer) , colorbar, title('b) horizontal edge map') ;
subplot(2,2,3) , mesh(flipud(ay)) , view(2), colormap(summer) , colorbar, title('c) vertical edge map') ;
%
% we might need memory, se we clear two unnecessary matrices and continue
% the illustration
clear ax ay 
subplot(2,2,4) , mesh(flipud(a)) , view(2), colormap(summer) , colorbar, title('d) Sobel edge strength map') ;
%
% we keep all the points bigger than the tr percentage of the maximum edge
% power and eliminate the others. therefore the edge strength map will be
% converted to a binary image including only edges and lines
tr = tr * max(max(a)) ;
a = uint8( (a>=tr) ) .* 200 ;
% we show it in figure 2 , .* 200 is for better contrast i.e. now we have a
%  0-200 binary image !!
figure(2) ;
imshow(a) , title('binary edge image') ; 
% finished ........
return