%
%
%

function  manfi2() 

a = imread('s13.png') ;
display('preparation of the processing environment ...') ;
figure(2) ;
subplot(3,3,2) , imshow(a) ; 

display('mapping') ;
[m,n,k] = size(a) ;
for j=320:40:910
    a(j:j+39,50:350,1) = 255 - a(j:j+39,50:350,1)  ;
    a(j:j+39,370:700,2) = 255 - a(j:j+39,370:700,2)  ;
    a(j:j+39,705:950,3) = 255 - a(j:j+39,705:950,3)  ;
    subplot(3,3,4) , imshow(a(:,:,1)) , colormap(autumn) ;
    subplot(3,3,5) , imshow(a(:,:,2)) , colormap(summer) ;
    subplot(3,3,6) , imshow(a(:,:,3)) , colormap(winter) ;
    pause(3) ;
    printf('\nProcessing row %5d',j) ;
  
endfor

printf('\n\n') ;
display('reducing') ;
subplot(3,3,8) , imshow('s14.png') ; 
figure(1)
imshow('s14.png') ; 

return