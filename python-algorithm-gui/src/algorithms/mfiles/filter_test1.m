% a simple program to show the image convolution and filter responses
%
% amir - 2020

close all
clear all
clc

fnam = input('Image file name > ','s') ;
a = imread(fnam) ;
[M,N,K] = size(a) ;
if (K==3)
  a = rgb2gray(a) ;
endif

figure(1) 
imshow(a) , title(fnam) ;
hh = [-1 -2 -1 ; 0  0  0 ; 1  2  1] ;
hv = hh' ;
a = double(a) ;
bh = conv2( a , hh , 'valid' ) ;
bv = conv2( a , hv , 'valid' ) ;
figure(2)
subplot(1,2,1) , imshow( uint8(bh) ) , colormap(gray) , title('horizontal filtering') ;
subplot(1,2,2) , imshow( uint8(bv) ) , colormap(gray) , title('vertical filtering') ;
sbh = sum(sum(bh .^ 2)) ./ prod( size( bh ) ) ;
sbv = sum(sum(bv .^ 2)) ./ prod( size( bv ) ) ;
sa = sum(sum(a .^ 2)) ./ prod( size( a ) ) ;
figure(2)
subplot(1,2,1) , imshow( uint8(bh) ) , colormap(gray) , title(['horizontal filtering, Power=',num2str(sbh)]) ;
subplot(1,2,2) , imshow( uint8(bv) ) , colormap(gray) , title(['vertical filtering, Power=',num2str(sbv)]) ;
printf('\n\n Power/response to horizontal filter: %f \n Power/response to vertical filter: %f \n',sbh,sbv) ;
printf(' Original Image Power: %f \n',sa) ;
res1 = (abs(bh) + abs(bv)) ./2 ;
figure(3)
imshow( uint8(res1) ) , colormap(gray) , title('Edges Map') ;

%%  max pooling 2x2
%res1 = abs(bh) + abs(bv) ;
res2 = [] ;
[mm,nn] = size(res1) ;
for i=1:2:mm-1
  xx = [] ;
  for j=1:2:nn-1
    xx = [xx , max( max( res1(i:i+1,j:j+1) ) ) ] ;
  endfor
  res2 = [ res2 ; xx ] ;
endfor

figure(4) ;
% mesh(flipud(res2)) , view(2) ;
imshow( uint8(res2) ) , colormap(gray) , title('after max pooling') ;

%% relu 
res2 = (res2>=0) .* res2 ;
figure(5) ;
% mesh(flipud(res2)) , view(2) ;
imshow( uint8(res2) ) , colormap(gray) , title('after relu') ;

return
