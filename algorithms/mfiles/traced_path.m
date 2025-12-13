%
%
%

function trpath = traced_path( namdat , mnid )
  [M , N] = size(mnid) ;
  trpath='{' ;
  for i=1:N
    trpath = [ trpath , cell2mat(namdat(mnid(i))) ] ;
    if (i<N)
      trpath = [ trpath ,  ' --> '] ;
    endif
  endfor
  trpath = [ trpath , '}'] ;
endfunction
