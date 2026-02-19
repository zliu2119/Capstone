
%
function y = am_gauss(x, mu,st, mode)
  if (mode == 'n' || mode =='N')
      y= (1/(2*pi*st^2)) .* e .^ -((x-mu) .^ 2 ./ 2 ./ st^2) ;
  else
       y= e .^ -((x-mu) .^ 2 ./ 2 ./ st^2) ;
  endif    
endfunction
