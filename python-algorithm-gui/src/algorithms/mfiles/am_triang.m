%
%
%
function y = am_triang(x, x1,x2,x3) 
  y=zeros(size(x)) ;
  m1 = 1/ (x2-x1) ;
  m2 = 1 / (x2-x3) ;
  for i=1:size(x')
    if (x(i)>=x1 && x(i)<x2 ) 
      y(i) =  m1* x(i) - m1*x1 ;
    elseif (x(i)>=x2 && x(i)<x3)
      y(i) =  m2 * x(i) - m2*x3 ;
    endif
  endfor
endfunction

