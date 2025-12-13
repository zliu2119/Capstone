%
%
%

function hmc = h_m_conflict(a,i,j)
  
  hmc= 0 ;
  [N,N] = size(a) ;
  for ii=1:N
    hmc = hmc + a(ii,j) ;
    hmc = hmc + a(i,ii) ;
  endfor
  
  ii=i ;
  jj=j ;
  while (ii>=1 && jj>=1)
    hmc = hmc + a(ii,jj) ;
    ii= ii-1 ;
    jj= jj-1 ;
  endwhile
  
  ii=i ;
  jj=j ;
  while (ii<=N && jj<=N)
    hmc = hmc + a(ii,jj) ;
    ii= ii+1 ;
    jj= jj+1 ;
  endwhile

  ii=i ;
  jj=j ;
  while (ii<=N && jj>=1)
    hmc = hmc + a(ii,jj) ;
    ii= ii+1 ;
    jj= jj-1 ;
  endwhile
  
  ii=i ;
  jj=j ;
  while (ii>=1 && jj<=N)
    hmc = hmc + a(ii,jj) ;
    ii= ii-1 ;
    jj= jj+1 ;
  endwhile
hmc = hmc - 6 ;
  
endfunction
