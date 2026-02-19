


function scor = score_n_queen2(a)
  
  scor=0 ;
  [N,M] = size(a) ;
  
  if ( N ~= M)
    display('error ! input matrix should be square') ;
    scor = -1 ;
  endif
  if ( sum(sum(a)) ~= N)
    display('error ! no N Queens on the board') ;
  endif
  
  for i=1:N
    for j=1:N
      if (a(i,j) == 1)
        scor = scor + h_m_conflict(a,i,j) ;
      endif
    endfor
  endfor
  
   
endfunction

