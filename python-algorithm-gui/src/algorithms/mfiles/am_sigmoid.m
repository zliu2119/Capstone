%
%
%
function y = am_sigmoid(x, a,b) 
  y= b ./ (1+e .^(-a .* x)) ;
endfunction
