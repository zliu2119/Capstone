%
%  Butterworth 2 dim filter matrix 
% input : M,N,D0 , grade , i ,j
% output : (i,j) element a M*N filter matrix called h 
% which : H(u,v) = butterworth marix in grade GRADE
% note : mostly , 2 is a good value for GRADE parameter .
% amir nov 2000
%
function hres = butter_filt2( m,n,d0,grade)

hres = zeros(m,n) ;
u = m/2 ;
v = n/2 ;
for i=1:m
   for j=1:n
      hres(i,j) = 1 / ( 1 + ( (( (i-u)^2 + (j-v)^2 )^0.5) / d0 )^(2*grade) ) ;
   end
end


return
