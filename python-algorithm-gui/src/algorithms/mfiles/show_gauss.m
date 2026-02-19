%
%
%

function show_gauss(n, d_dim, dnv, dmv, dfv, onvan)
  x=d_dim(1):d_dim(2) ;
  f = exp( -0.5 .* ((x-dnv(2)) ./ dnv(1)).^2) ; 
  figure(n) ;
  plot(x,f,'r') ;
  f = exp( -0.5 .* ((x-dmv(2)) ./ dmv(1)).^2) ;
  hold on ;
  plot(x,f,'b') ;
  f = exp( -0.5 .* ((x-dfv(2)) ./ dfv(1)).^2) ;
  hold on ;
  plot(x,f,'g') ;
  title(onvan) ;
  hold off ;
  
endfunction
