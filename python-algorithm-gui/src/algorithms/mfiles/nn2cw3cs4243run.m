
clc
clear all
close all
load 126
net.w1
net.w2
net.b1
net.b2

x1=[0,0] ;
pp = x1*net.w1 + net.b1
ppp = 1 ./ (1+exp(-pp)) ;
qq = ppp * net.w2 ;
qq = ppp * net.w2 + net.b2
z=1/(1+exp(-qq)) ;
fprintf('\n x1= [%3d , %3d] : \t\t, z=%5.3f\n-----------------------\n',x1,z) ;

x1= [0,1];
pp = x1*net.w1 + net.b1
ppp = 1 ./ (1+exp(-pp));
qq = ppp * net.w2;
qq = ppp * net.w2 + net.b2
z=1/(1+exp(-qq));
fprintf('\n x1= [%3d , %3d] : \t\t, z=%5.3f\n------------------------\n',x1,z) ;

x1=[1,0] ;
pp = x1*net.w1 + net.b1
ppp = 1 ./ (1+exp(-pp)) ;
qq = ppp * net.w2 ;
qq = ppp * net.w2 + net.b2
z=1/(1+exp(-qq)) ;
fprintf('\n x1= [%3d , %3d] : \t\t, z=%5.3f\n-------------------------\n',x1,z) ;

x1= [1,1];
pp = x1*net.w1 + net.b1
ppp = 1 ./ (1+exp(-pp));
qq = ppp * net.w2;
qq = ppp * net.w2 + net.b2
z=1/(1+exp(-qq));
fprintf('\n x1= [%3d , %3d] : \t\t, z=%5.3f\n--------------------------\n',x1,z) ;

