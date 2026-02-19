%
%
%

function b = am_median_filt(a,m)

b = zeros(size(a)) ;
[mm,nn,kk] = size(a) ;
for k=1:kk
  b(:,:,k) = medfilt2(a(:,:,k), [m,m] ) ;
endfor

return
