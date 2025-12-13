%
% Linear Regression, V2.0
% y=f(x)
% Amir - 2021
%
clc
clear all
close all
 
ncf = 1 ;
prompt = {"Noise Factor:"};
rowscols = [1,12 ];
dims = inputdlg (prompt, "Linear Regression Example", rowscols);
ncf = str2num( cell2mat(dims(1))) ;
x = [-5:0.1:5] ;
[nn, N] = size(x) ;
y = -4 .* x + 3.25 + ncf* randn(1,N) ;
figure(1)
hold on ;
plot(x,y,'r+') ;

Z = [ ones(N,1) x(:) ] ;
a = (Z.' * Z) \ (Z.' * y(:)) ;   % a = y * pinv(Z)
yp = x .* a(2) + a(1) ;

ttext = ['Linear Model: Slope=', num2str(a(2)),',  Intercept=',num2str(a(1)),',  as Noise Coef=',num2str(ncf)] ;
figure(1) , plot(x,yp) ;
title(ttext) ;
printf('\n\n %s \n',ttext ) ;
msgbox(ttext) ;

return