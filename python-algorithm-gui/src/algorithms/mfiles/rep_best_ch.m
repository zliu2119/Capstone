%
%
%
%

function [pup11 , fn_array11] = rep_best_ch(best_ch , best_ftn , pup , fn_array)
   pup11 = pup ;
   fn_array11 = fn_array ;
   [m,n] = size( best_ftn ) ;
   pup11(1:m,:) = best_ch ;
   fn_array11(1:m) = best_ftn ;
endfunction