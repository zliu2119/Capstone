%
%
% logistic function demo, amir Feb 2020 ...
%
%
clc ;
close all ;
clear all ;

x=[-100:0.1:100] ;
ab = input('Enter [alpha and beta[ coefficients: ') ;

while (size(ab) ~=0)
  y = 1 ./ (1+ ab(1,2) .* exp(-ab(1,1) .* x) ) ;
  figure ;
  plot(x,y) ;
  title(['sigmoid function ' , num2str(ab(1,1)) ,'  ', num2str(ab(1,2)) ] ) ;
  ab = input('Enter [alpha and beta[ coefficients: ') ;
endwhile
