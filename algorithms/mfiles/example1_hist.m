% example 1: histogram equalization
% 
% amir monadjemi - 2015
%

% house keeping operations before starting the main processes
% clear the workspace and all variable
% closing all figures
% clearingthe console and text
%
clear all
close all
clc

% reading the image file name, the user enters it
fnam = input('enter the image file name: ' , 's') ;
% reading/loading the image into a matrix, a is mxnx3 for rgb true color
% images
a = imread(fnam) ;

% generating figure window #1
figure(1);
% using subplot function to have a multi figure window. 
% subplot(m,n,k) means having m rows, and n columns, in the figure window, 
% and showing the object % in its kth place.
% imshow is a good useful function for showuing images. title is the header
% string concatination is easy, stringis an array of characters within [],
% so you can concat constant strings and string variables within a [] !!
% see the title parameter
subplot(2,2,1) , imshow(a) , title(['a) original image  ' , fnam]) ;
% applying a median filter on all 3 color plates using medfilt2 function. 
% filter window size is 11x11. ifthe 2nd parameter is not mentioned,
% defaultis 3x3.
% now wehave a filtered version of a in the matrix b,
for i=1:3
    b(:,:,i) = medfilt2(a(:,:,i) , [5,5]) ;
    %%b(:,:,i) = conv2(a(:,:,i) , [0.25 0.25 ; 0.25 0.25], 'valid') ;
end
% showing the results, using subplot again, all 3 color plates
subplot(2,2,2) , imhist(b(:,:,1)) , title('b) red channel histogram') ;
subplot(2,2,3) , imhist(b(:,:,2)) , title('c) green channel histogram') ;
subplot(2,2,4) , imhist(b(:,:,3)) , title('d) blue channel histogram') ;

% histograms of all 3 color plates are equalized using histeq function. 
b = double(b) ./ 255 ;
for i=1:3
    b(:,:,i) = histeq( b(:,:,i), 256 ) ;
end
% next figure with handle #2, showing the effects of histogram equalization
% on each color channel/plates and the whole image
figure(2);
subplot(2,2,1) , imshow(uint8(b .* 255)) , title(['a) after equalization']) ;
subplot(2,2,2) , imhist(b(:,:,1)) , title('b) red channel histogram') ;
subplot(2,2,3) , imhist(b(:,:,2)) , title('c) green channel histogram') ;
subplot(2,2,4) , imhist(b(:,:,3)) , title('d) blue channel histogram') ;
% saving the result as a new image using imwrite function,matrix, file name
% andthe format is mentioned.
% imwrite(b, ['eq_' ,fnam] ,'jpg');

% see you ....
return
