%
%
%

function ffnn = compute_fitness_sudoku(population)
  
  [M,N] = size(population) ;
  ffnn = zeros(M,1) - 1 ;
  n = N ^ 0.5 ;
  
  for i=1:M
    a = reshape( population(i,:) , n , n)  ;
    ffnn(i) = score_sudoku2(a) ;
  endfor
 ffnn 
 
endfunction
