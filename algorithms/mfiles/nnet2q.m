% Generate the matrix of inputs x and targets t.
% 
%%
%
clc
close all
clear all
[numdat , txtdat ] = xlsread('resale19.xlsx') ;
[M,N] = size(numdat) 

x1 = numdat(1:M-200,1:N-1) ;
x2 = numdat(M-199:M,1:N-1) ;
t1= numdat(1:M-200,N) ;
t2 = numdat(M-199:M,N) ;


figure(1) ;
plot( y, 'ob')
hold on ;
plot(t2,'r.') ;
immse(y,t2)
figure(2) ;
plot( round(y), 'ob')
hold on ;
plot(t2,'r.') ;
immse(round(y),t2)
printf('\n\n Classification Accurac = %f \n\n', 1 - sum(abs(t2-round(y)))/prod(size(t2))) ;
return
