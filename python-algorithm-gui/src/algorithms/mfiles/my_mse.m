% MSE Error 
% matrices should have got the size, maximum dimension=4
% Amir - 2021

function rr = my_mse(y1,y2)
  
  rr = sum(sum(sum(sum((y1-y2) .^2)))) ./ prod(size(y1)) ;

endfunction