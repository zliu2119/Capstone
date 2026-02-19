%
% macro 2
%
close all
clear all

a = imread("F:\\imoortant\\applied_AI\\multimedia\\96-967172_building-advanced-ai-features-and-establishing-a-data.png") ;
imshow(a) ;

b = imread("F:\\imoortant\\applied_AI\\multimedia\\dc08-4836-ae87-4fcf6a3cde59.jpg") ;
figure ;
imshow(b) ;
[m1,n1,k] = size(a) ;
[m2,n2,p] = size(b) ;

if (k != 3 || p !=3)
  display('RGB image is needed') ;
  return ;
endif
if (m1*n1>m2*n2)
  b = imresize(b,[m1,n1]) ;
else
  a = imresize(a,[m2,n2]) ;
endif

k=rand() ;
a = double(a).*k + double(b).*(1-k) ;
a=uint8(a) ;

figure ;
imshow(a) ;
imwrite(a,"F:\\imoortant\\applied_AI\\multimedia\\establishing-a-data3.png") ; 

return
