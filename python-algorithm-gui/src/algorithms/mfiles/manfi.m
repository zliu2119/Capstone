%
%
%

function  manfi(a) 

display('preparation of the processing environment ...') ;
figure(2) ;
subplot(3,3,2) , imshow(a) ;
h= [ 1 -1 ; -1 1] ;
b=a ;
for i=1:3
  b(:,:,i) = conv2(a(:,:,i) , h , 'same') ;
endfor
display('mapping') ;
[m,n,k] = size(a) ;
for i=1:40:m-40
  for j=1:40:n-40
    a(i:i+39,j:j+39,1) = 255 - a(i:i+39,j:j+39,1)  ;
    a(i:i+39,j:j+39,2) = 255 - a(i:i+39,j:j+39,2)  ;
    a(i:i+39,j:j+39,3) = 255 - a(i:i+39,j:j+39,3)  ;
    
    subplot(3,3,4) , imshow(a(:,:,1))  ;
    subplot(3,3,5) , imshow(a(:,:,2))  ;
    subplot(3,3,6) , imshow(a(:,:,3))  ;
    if (i<200)
      pause(3) ;
    endif
    printf('\nProcessing row %5d\t column %5d',i,j) ;
  endfor
    
endfor

printf('\n\n') ;
display('reducing') ;
subplot(3,3,8) , imshow(uint8(abs(b))) ; 
figure(1)
imshow(uint8(abs(b .* 1.2))) ; 

return