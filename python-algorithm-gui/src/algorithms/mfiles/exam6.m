%
%
% to solve the 2nd order equation
%
clear all ;
close all ;
clc ;
x = -20:0.1:20 ;
z = input('enter a and b and c coefficients : ') ;
while (size(z) ~= 0)
  a = z(1) ;
  b = z(2) ; 
  c = z(3) ;
  [dlt,cnd] = my_delta(a,b,c) ;
  if (cnd==-1) 
    display('delta is less than zero, no root') ;
  elseif (cnd==0)
    x1 = -b / (2 * a );
    fprintf('\nDelta=0 , double root = %f\n' , x1) ; 
  else
    x1 = ( -b + dlt^0.5 ) / (2*a) ;
    x2 = ( -b - dlt^0.5 ) / 2 / a ;
    fprintf('\n roots = %f \t %f\n' , x1,x2) ;
  endif
  y = a*x.^2+b*x+c ;
  plot(x,y,'b') ;
  z = input('enter a and b and c coefficients : ') ;
endwhile
return

