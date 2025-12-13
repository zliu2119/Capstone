%
%
%

function pup = build_pup_tsm(N,M)

  pup = [] ;
  ttmmpp = 2:N-1 ;
  for i =1:M
    for j = 1:N/2
      s1 = randi(N-2) ;
      s2 = randi(N-2) ;
      a=ttmmpp(s1) ;
      ttmmpp(s1) = ttmmpp(s2) ;
      ttmmpp(s2) = a ;
    endfor
    pup = [ pup ; [ 1 , ttmmpp , 1] ] ;
  endfor
  
endfunction

