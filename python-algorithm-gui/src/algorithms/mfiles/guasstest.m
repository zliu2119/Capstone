clc
clear all
close all

x=[-20:0.1:20] ;
y = am_gauss(x, 0,0.2, 'n') ;
figure
plot(y), title(' 0,0.2, n') ;
y = am_gauss(x, 0,1, 'n')
figure
plot(y), title(' 0,1, n') ;
y = am_gauss(x, 0,3, 'n')
figure
plot(y), title(' 0,3, n') ;
y = am_gauss(x, 0,7, 'n')
figure
plot(y) , title(' 0,7, n') ;

return