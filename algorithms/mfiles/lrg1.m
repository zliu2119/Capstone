%
% Linear Regression, V2.0
% y=f(x)
% Amir - 2021
%
clc
clear all
close all
 
ncf = 3.2 ;
x = [-5:0.1:5] ;
[nn, N] = size(x) ;
y = -4 .* x + 3.25 + ncf* randn(1,N) ;
figure(1)
hold on ;
plot(x,y,'r+') ;

r = rand(1,N) .* 3 ;
figure(2) ;
hold on ;
plot(x,r,'b+') ;

Z = [ ones(N,1) x(:) ] ;

a = (Z.' * Z) \ (Z.' * y(:)) ;   % a = y * pinv(Z)

b = (Z.' * Z) \ (Z.' * r(:)) ;   % b = r * pinv(Z)

yp = x .* a(2) + a(1) ;
figure(1) , plot(x,yp) ;
rp = x .* b(2) + b(1) ;
figure(2) , plot(x,rp) ;
printf('\n\n First Example: Slope= %f , Intersection= %f\n', a(2) , a(1) ) ;
printf('\n\n Second Example: Slope= %f , Intersection= %f\n', b(2) , b(1) ) ;
 
return