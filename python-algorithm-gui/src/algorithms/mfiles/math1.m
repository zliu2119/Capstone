%
%
%

%---------------------------- 

dt=0.000001 ;

a = input('base > ') ;
t= -10:0.1:10 ;
y = a .^ t ;
dy = ( a .^ (t+dt) - a .^ t ) ./ dt 
figure(1) ;
plot(t,y,'r.',t,dy,'b.') ;

figure(2) ;
plot(t,y-dy) ;

%------------------------------ 

t= 0:0.1:10 ;
z = loga(t,a) ;
dz = ( loga(t+dt,a) - loga(t,a) ) ./ dt ;
figure(3) ;
plot(t,dz,'r.',t,1./t,'b.') ;

figure(4) ;
plot(t,dz-1./t) ; 

return

