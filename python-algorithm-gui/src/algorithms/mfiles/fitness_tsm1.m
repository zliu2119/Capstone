%
%
%

function ft = fitness_tsm1(pup,rdata)
  ft=[] ;
  [M,N] = size(pup) ;
  for i=1:M
    s = 0 ;
    for j=1:N-1
      s = s + rdata( pup(i,j) , pup(i,j+1) ) ;
    endfor
    ft = [ft ; s ] ;
  endfor
endfunction
