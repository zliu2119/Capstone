%
%
%

function scor = score_sudoku2(a)
  
  scor=0 ;
  [N,M] = size(a) ;
  
  if ( N ~= M)
    display('error ! input matrix should be square') ;
    scor = -1 ;
  endif
  for i=1:2
    for j=1:N
      scor = scor + beshmar(a(j,:),N) ;
    endfor
    a=a' ;
  endfor
  a=a' ;
  
  stmp = 0 ;
  for i=[1,4,7]
    for j=[1,4,7]
      b = reshape(a(i:i+2,j:j+2),1,N) ;
      scor = scor + beshmar(b,N) ;
    endfor
  endfor
  
endfunction

