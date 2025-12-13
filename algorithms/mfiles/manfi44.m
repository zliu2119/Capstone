%
%
%

function  manfi44(NN) 

NN
a = imread('s13.png') ;
display('preparation of the processing environment ...') ;
figure(2) ;
subplot(3,3,2) , imshow(a) , title('main data') ; 
b= a ;
c= a ;
d= a ;
e= a ;
f= a ;
display('mapping') ;
[m,n,k] = size(a) ;
if NN==3
  for j=320:40:910
    a(j:j+39,50:350,1) = 255 - a(j:j+39,50:350,1) ;
    a(j:j+39,370:700,2) = 255 - a(j:j+39,370:700,2) ;
    a(j:j+39,705:950,3) = 255 - a(j:j+39,705:950,3) ;
    subplot(3,3,4) , imshow(a(:,:,1)) , colormap(autumn), title('node 1')  ;
    subplot(3,3,5) , imshow(a(:,:,2)) , colormap(summer) , title('node 2')  ;
    subplot(3,3,6) , imshow(a(:,:,3)) , colormap(winter) , title('node 3')  ;
    pause(3) ;
    printf('\nProcessing row %5d',j) ;
  endfor
elseif NN==4
  for j=320:40:910
    b(j:j+39,50:300,1) = 255 - b(j:j+39,50:300,1)  ;
    c(j:j+39,300:600,2) = 255 - c(j:j+39,300:600,2)  ;
    d(j:j+39,600:800,3) = 255 - d(j:j+39,600:800,3)  ;
    e(j:j+39,800:950,1) = 255 - e(j:j+39,800:950,1)  ;
    subplot(3,3,3) , imshow(b) , title('node 1') ;
    subplot(3,3,4) , imshow(c) , title('node 2') ;
    subplot(3,3,5) , imshow(d) , title('node 3')  ;
    subplot(3,3,6) , imshow(e) , title('node 4')  ;
    pause(3) ;
    printf('\nProcessing row %5d',j) ;
  endfor
 else 
  for j=320:40:910
    b(j:j+39,50:250,1) = 255 - b(j:j+39,50:250,1)  ;
    c(j:j+39,250:500,2) = 255 - c(j:j+39,250:500,2)  ;
    d(j:j+39,500:700,3) = 255 - d(j:j+39,500:700,3)  ;
    e(j:j+39,700:800,3) = 255 - e(j:j+39,700:800,3)  ;
    f(j:j+39,800:950,1) = 255 - f(j:j+39,800:950,1)  ;
    subplot(3,3,3) , imshow(b) , title('node 1') ;
    subplot(3,3,4) , imshow(c) , title('node 2') ;
    subplot(3,3,5) , imshow(d) , title('node 3')  ;
    subplot(3,3,6) , imshow(e) , title('node 4')  ;
    subplot(3,3,7) , imshow(f) , title('node 5')  ;
    
    pause(3) ;
    printf('\nProcessing row %5d',j) ;
  endfor
endif

printf('\n\n') ;
display('reducing') ;
subplot(3,3,8) , imshow('s14.png')  , title('result') ; 
figure(1)
imshow('s14.png') ; 
tt = 37.58 ;
printf('\n\nTime comparison: one node=%6.2f sec, vs %3d nodes=%6.2f sec.\n',tt,NN,tt/NN+NN/10) ;
 
return