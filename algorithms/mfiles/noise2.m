%
%
%

function a = noise2(a,level)

[M,N,K] = size(a) ;
level = round(level * M * N) ;
for i=1:level
  m1 = randi(M) ;
  n1 = randi(N) ;
  m2 = randi(M) ;
  n2 = randi(N) ;
  tmp = a(m1,n1,:) ;
  a(m1,n1,:) = a(m2,n2,:) ;
  a(m2,n2,:) = tmp ;
endfor

return