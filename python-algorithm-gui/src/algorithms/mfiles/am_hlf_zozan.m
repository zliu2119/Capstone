%
%
%
function y = am_hlf_zozan(x, x1,x2) 
  y=zeros(size(x)) ;
  m1 = 1/ (x2-x1) ;
  for i=1:size(x')
    if (x(i)>=x1 && x(i)<x2 ) 
      y(i) =  m1* x(i) - m1*x1 ;
    elseif ( x(i)>=x2 )
      y(i) =  1 ;
    endif
  endfor
endfunction

