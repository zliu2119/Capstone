close all
clear all
clc

t=[-5:0.01:5] ;
y=sin(2*pi*t) ;
figure(1)
plot(y) , title('Sin function'); 
a= corr(y,y) ;
printf('\n\n Auto correlation= %f FIG 1',a) ; 
x=y;

a= corr(x,y) ;
printf('\n\n Correlation between X and Y= %f',a) ; 
x=x+rand(size(x)) ;
figure(2)
plot(x) , title('sin + noise') ;
a=corr(x,y);
printf('\n\n Correlation after adding noise= %f  FIG 2',a) ; 
x=x+rand(size(x)) ;
x=x+rand(size(x)) ;
figure(3)
plot(x) , title('sin + more noise') ;
a=corr(x,y);
printf('\n\n Correlation after adding more noise= %f  FIG 3',a) ; 
x=x+rand(size(x)) ;
x=x+rand(size(x)) ;
figure(4)
plot(x) , title('sin + more and more noise') ;
a=corr(x,y);
printf('\n\n Correlation after adding more noise= %f  FIG 4',a) ; 
z=cos(2*pi*t);
figure(1)
hold on
plot(z) , title('sin (b) & cos (r) function') ;
a=corr(z,y);
printf('\n\n Correlation between sin and cosine= %f  FIG 1',a) ; 
a=corr(z,x);
printf('\n\n Correlation noisy sin and cosine= %f FIG 5',a) ; 
figure(5)
title('noisy sin and cosine') ;
plot(z) ;
hold on ;
plot(x) ;

r1= rand(1,200) ;
r2= rand(1,200) ;
figure(6)
title('random signals r1 and r2') ;
plot(r1) ;
hold on ;
plot(r2) ;
printf('\n\n Correlation between randoms= %f  FIG 6',corr(r1,r2) ) ; 

r2=-r1 ;
printf('\n\n Correlation between r1 and -r1= %f  FIG 7\n\n',corr(r1,r2) ) ; 
figure(7)
title('random signals r1 and -r1') ;
plot(r1) ;
hold on ;
plot(r2) ;

return
