%
%
%

function  manfi4(a,NN) 

display('preparation of the processing environment ...') ;
figure(2) ;
subplot(3,3,2) , imshow(a) , title('original image') ;
h= [ 1 -1 ; -1 1] ;
b=a ;
c1= a ;
c2= a ;
c3= a ;
c4= a ;
c5= a ;
for i=1:3
  b(:,:,i) = conv2(a(:,:,i) , h , 'same') ;
endfor
display('mapping') ;
[m,n,k] = size(a) ;
if NN==3 
  for i=1:40:m-40
    for j=1:40:n-40
      a(i:i+39,j:j+39,1) = 255 - a(i:i+39,j:j+39,1)  ;
      a(i:i+39,j:j+39,2) = 255 - a(i:i+39,j:j+39,2)  ;
      a(i:i+39,j:j+39,3) = 255 - a(i:i+39,j:j+39,3)  ;
      subplot(3,3,4) , imshow(a(:,:,1)) , title('Red Channel') ;
      subplot(3,3,5) , imshow(a(:,:,2)) , title('Green Channel')   ;
      subplot(3,3,6) , imshow(a(:,:,3)) , title('Blue Channel')  ;
      if (i<200)
        pause(2) ;
      endif
      printf('\nProcessing row %5d\t column %5d',i,j) ;
    endfor
  endfor
elseif NN==4
  for i=1:40:n/4-40
    c1(:,i:i+39,1) = 255 - c1(:,i:i+39,1) ;
    c2(:,i+n/4:i+n/4+39,2) = 255 - c2(:,i+n/4:i+n/4+39,2) ;
    c3(:,i+n/2:i+n/2+39,2) = 255 - c3(:,i+n/2:i+n/2+39,2) ;
    c4(:,i+3*n/4:i+3*n/4+39,3) = 255 - c4(:,i+3*n/4:i+3*n/4+39,3) ;
    
    subplot(3,3,3) , imshow(c1) , title('node 1') ;
    subplot(3,3,4) , imshow(c2) , title('node 2') ;
    subplot(3,3,5) , imshow(c3) , title('node 3') ;
    subplot(3,3,6) , imshow(c4) , title('node 4') ;
    pause(4) ;
    printf('\nProcessing row %5d',i) ;
  endfor
else
  for i=1:40:n/5-40
    c1(:,i:i+39,1) = 255 - c1(:,i:i+39,1) ;
    c2(:,i+n/5:i+n/5+39,2) = 255 - c2(:,i+n/5:i+n/5+39,2) ;
    c3(:,i+2*n/5:i+2*n/5+39,2) = 255 - c3(:,i+2*n/5:i+2*n/5+39,2) ;
    c4(:,i+3*n/5:i+3*n/5+39,3) = 255 - c4(:,i+3*n/5:i+3*n/5+39,3) ;
    c5(:,i+4*n/5:i+4*n/5+39,3) = 255 - c5(:,i+4*n/5:i+4*n/5+39,3) ;
    subplot(3,3,3) , imshow(c1) , title('node 1') ;
    subplot(3,3,4) , imshow(c2) , title('node 2') ;
    subplot(3,3,5) , imshow(c3) , title('node 3') ;
    subplot(3,3,6) , imshow(c4) , title('node 4') ;
    subplot(3,3,7) , imshow(c5) , title('node 5') ;
    pause(4) ;
    printf('\nProcessing row %5d',i) ;
  endfor

endif

printf('\n\n') ;
display('reducing') ;
subplot(3,3,8) , imshow(uint8(abs(b))) , title('result') ; 
figure(1)
imshow(uint8(abs(b .* 1.2))) ; 
tt = 21.19 ;
printf('\n\nTime comparison: one node=%6.2f sec, vs %3d nodes=%6.2f sec.\n',tt,NN,tt/NN+NN/10) ;
 
return