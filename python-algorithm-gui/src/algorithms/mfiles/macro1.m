%
% macro 1
%
close all
clear all

a = imread("C:\\Users\\amir.m\\Desktop\\logicalagent.png") ;
imshow(a) ;

%a = fliplr(a) ;

a = 255 - a ;

%a = noise1(a, 5) ;

a = color_swap(a) ;

%a = noise2(a,0.05) ;

%for i=1:3
 % a(:,:,i) = uint8( conv2( double(a(:,:,i)) , [ -1 -1 -1 ; -1 9 -1 ; -1 -1 -1] , 'valid' ) )
%endfor
figure ;
imshow(a) ;
imwrite(a,"C:\\Users\\amir.m\\Desktop\\657logicalagent.png") ;

return
