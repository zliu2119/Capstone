%
%
%
clear all
close all force
clc

fn = input('image > ','s') ;
fn2 = ['res_' , fn] ; 
a = imread(fn) ;
figure ;
imshow(a) ;
b = rgb2hsv(a) ;
figure ;
subplot(2,2,1) , imshow(b) ;
for i=2:4
  subplot(2,2,i) , surf(b(:,:,i-1)) , view(2) , colormap(gray) , colorbar ;
endfor
b(:,:,1) = 1 - b(:,:,1) ;
a = hsv2rgb(b) ;
figure ;
imshow(a) ;

return 