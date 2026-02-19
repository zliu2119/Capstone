

function scor = score_n_queen(a)
  
  scor=0 ;
  [N,M] = size(a) ;
  if ( N ~= M)
    display('error ! input matrix should be square') ;
    score = -1 ;
  endif
  if ( sum(sum(a)) ~= N)
    display('error ! no N Queens on the board') ;
  endif
  sr = sum(a) ;
  for i=1:N
    scor = scor + abs(sr(i)-1) ;
  endfor
  a=a' ;
  sr = sum(a) ;
  for i=1:N
    scor = scor + abs(sr(i)-1) ;
  endfor
  a=a' ; 
  
endfunction
