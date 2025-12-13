clear 
clc
close all

fid1 = imread('small_IMG_0247.jpg') ;

figure ;
subplot(2,2,1) , imshow(fid1) , title('original image') ;
subplot(2,2,2) , mesh( flipud(double(fid1(:,:,1))) ) , title('Red Channel') , colorbar  , view(2);
subplot(2,2,3) , mesh( flipud(double(fid1(:,:,2))) ) , title('Green Channel') , colorbar , view(2) ;
subplot(2,2,4) , mesh( flipud(double(fid1(:,:,3))) ) , title('Blue Channel') , colormap(winter) , colorbar , view(2) ;

return
