%
%
% to solve the 2nd order equation
%

z = input('enter a and b and c coefficients : ') ;
a = z(1) ;
b = z(2) ;
c = z(3) ;
dlt = b^2-4*a*c ;
if (dlt<0) 
  display('delta is less than zero, no root') ;
  return
endif
if (dlt==0)
  x = -b / (2 * a );
  printf('\nDelta=0 , root = %f\n' , x) ;
  return 
endif

x1 = ( -b + dlt^0.5 ) / (2*a) ;
x2 = ( -b - dlt^0.5 ) / 2 / a ;

printf('\n roots = %f \t %f\n' , x1,x2) ;
x11 = min(x1,x2) ;
x22 = max(x1,x2) ;
x = x11-5:0.1:x22+5 ; 
y = a*x.^2+b*x+c ;
plot(x,y,'b') ;

y2 =  zeros(size(x)) ;
hold on ;  
plot(x,y2,'r') ;

return
