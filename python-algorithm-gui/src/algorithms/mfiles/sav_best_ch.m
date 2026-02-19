%
%
%
function [best_ch , best_ftn] = sav_best_ch(pup , fn_array)
n=4 ;
best_ch = [] ;
best_ftn = [] ;

for i=1:n
  [_ , mindx ] = min(fn_array) ;
  best_ch = [best_ch ; pup(mindx , :) ] ;
  best_ftn = [best_ftn ; fn_array(mindx) ] ;
  fn_array(mindx) = 9999999999999 ;
endfor

endfunction
