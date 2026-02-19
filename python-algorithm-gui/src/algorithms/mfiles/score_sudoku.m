


function scor = score_sudoku(a)
  
  scor=0 ;
  [N,M] = size(a) ;
  
  if ( N ~= M)
    display('error ! input matrix should be square') ;
    scor = -1 ;
  endif
  sjam = sum(a) ;
  scor = scor + sum( abs(sjam -45)) ;
  a = a' ;
  sjam = sum(a) ;
  scor = scor + sum( abs(sjam -45)) ;
  a = a' ;
  
  stmp = 0 ;
  for i=[1,4,7]
    for j=[1,4,7]
      b = a(i:i+2,j:j+2) ;
      stmp = sum(sum(b)) ;
      scor = scor + abs(stmp-45) ;
    endfor
  endfor
  
endfunction

