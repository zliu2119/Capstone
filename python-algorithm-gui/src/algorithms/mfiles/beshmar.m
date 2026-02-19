%
%
%

function rrr = beshmar(aa,NN) 
  
  rrr = 0 ;
  for i=1:NN
    rrr = rrr + abs( sum((aa==i))-1) ;
  endfor
  
endfunction
