%
%
%
function am_pr_mat( mmt , key)

[mm,nn] = size(mmt) ;

for i=1:mm
  for j=1:nn
    printf( key , mmt(i,j) )
  endfor
  printf("\n")
endfor
return

