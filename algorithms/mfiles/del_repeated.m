%
%
%
function b = del_repeated( a ) 
  b="" ;
  [m,n] = size(a) ;
  for i=1:n
    if sum( uint8( b==a(i) ) ) == 0
      b = [ b , a(i) ] ;
    endif
  endfor
return 