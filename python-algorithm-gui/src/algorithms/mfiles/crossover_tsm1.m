%
%
%

function [kid1,kid2] = crossover_tsm1(father , mother) 
  
  fct=3 ;
  kid1 = father ;
  kid2 = mother ;
  [M , N] = size(father) ;
  r = randi([2,N-1]) ;
  for i=1:r/fct 
    p1 = randi([2,N-1]) ;
    kk = kid1(p1) ;
    p2 = find(kid2 == kk) ;
    kk2 = kid2(p1) ;
    kid2(p1) = kid2(p2) ;
    kid2(p2) = kk2 ;
  
    p1 = randi([2,N-1]) ;
    kk = kid2(p1) ;
    p2 = find(kid1==kk) ;
    kk2 = kid1(p1) ;
    kid1(p1) = kid1(p2) ;
    kid1(p2) = kk2 ;
  endfor
   
endfunction
