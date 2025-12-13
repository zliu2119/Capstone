%
%
%

function ffnn = compute_fitness(population , prsw)
  
  [M,N] = size(population) ;
  ffnn = zeros(M,1) - 1 ;
  for i=1:M
    a = zeros(N,N) ;
    for j=1:N
      a(population(i,j),j) = 1  ;
    endfor
    ffnn(i) = score_n_queen2(a) ;
  endfor
  if (toupper(prsw)=='Y') 
    ffnn 
  endif
 
endfunction
