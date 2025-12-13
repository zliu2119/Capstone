%
%
%

function pup11 = tsm_mutation(pup,mut)
 
 [M,N] = size(pup) ;
  pup11 = pup ;
  
  if ((mut==0) || (mut*M<1))
    return ;
  endif

  for i=1: mut*M
    r1 = randi(M) ;
    r2 = randi([2,N-1]) ;
    r3 = randi([2,N-1]) ;
    tmp = pup11(r1,r2) ;
    pup11(r1,r2) = pup11(r1,r3) ;
    pup11(r1,r3) = tmp ;
  endfor
 return
endfunction

