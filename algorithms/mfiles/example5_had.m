
% example 5
% Walsh/Hadamard Transform
%
% Amir Monadjemi, 2015

% house keeping
clear all
close all
clc
%
% we apply it on a single pre-defined image, 24bit gray scale, 1024x1024
fnam = 'IMG_0295_crop1_gl.jpg' ;
M=1024 ;
% diminished to N=64
N=64 ;
b = imread(fnam) ;
% b is gray scale, so we just use the 1st spectrum
b= b(:,:,1) ;
% original image is shown in figure 1
figure(1) ;
imshow(b) , title('original image') ;
% now using ordhad function, we build up a 1024x1024 sequency ordered 
% hadamard matrix in h, contains 1 and -1
h=ordhad(M) ;
% figure 2-1 shows the hadamard matrix. attention the increasing sequences of
% 1/-1 in rows and columns which build the square waves with various
% frequencies in both vertical/horizontal directions
figure(2)
subplot(1,2,1) , mesh(h), view(2) , title('1024x1024 Seq Ord Hadamard Matrix')  , colormap(summer) , colorbar;
% using transform matrix relation, we transfer our image into the hadamard
% domain, hb matrix and show it
hb = h*double(b)*h ;
subplot(1,2,2) , mesh(log(abs(hb)+1)), view(2) , title('Image in the transform domain, Log scale') , colormap(summer) , colorbar ;
% all the transformed image elements after Nth row and column become 0, so
% we just keep NxN elements (here N is 64), while the orginal matrix is MxM
% (here M is 1024)
hb(N:M ,:)=0 ;
hb(:,N:M)=0 ;
% we apply the inverse transform and bring the image back to the spatial
% domain, b2 matrix, and show it as mesh and iamge in Figure 3 and 4. 
% coefficient M^2 is applied for domain adjustment
b2 = h*hb*h ./ (M^2) ;
figure(3)
mesh(b2) , view(2) , title('Image after inverse transform') , colormap(gray) ;
figure(4) ;
imshow(uint8(b2)) , title('Image after inverse transform') ;

% Figure 5 shows the original image and image after transform domain
% process for a clearer comparison
figure(5) ;
subplot(1,2,2) , imshow(uint8(b2)) , title('Image after inverse transform') ;
subplot(1,2,1) , imshow(b) , title('Original image') ;
%
% for more exercise, we apply the hadamard transfomr once again, to have
% some fun ...
hb = h*double(b)*h ;
% then we change some elements of the transformed image into random 
% numbers between 0 and 5
hb(3:24,1:24) = rand*5 ;
hb(1:24,3:24) = rand*5 ;
% next is the inverse transform
b2 = h*hb*h ./ (M^2) ;
% shown in figure 6 and 7, the random numbers did this to our image, 
% shown with the original one 
figure(6) ;
imshow(uint8(b2)) , title('Distorted Image after inverse transform') ;

figure(7) ;
subplot(1,2,2) , imshow(uint8(b2)) , title('Distorted Image after inverse transform') ;
subplot(1,2,1) , imshow(b) , title('Original image') ;

% bye ......
return