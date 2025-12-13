%
%
%

function pup1 = mutation_sudoku(pup,mut,RNG)
  
  pup1 = pup ;
  [M,N] = size(pup) ;
  for i=1: mut*M
    r1 = randi(M) ;
    r2 = randi(N) ;
    r3 = randi(RNG) ;
    pup1(r1,r2) = r3 ;
  endfor
  
endfunction

