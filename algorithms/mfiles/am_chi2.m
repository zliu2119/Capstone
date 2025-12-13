%
%
%

function y = am_chi2(ooo,eee) 
  
  [nr,nc] = size(ooo) ;
  y= sum( (ooo-eee) .^ 2 ./ eee ) ;
  
endfunction
