%
%
%
cd  F:\imoortant\am_progs\cars\caartmp\car_side_2104_org
sz = input('New Size Ratio > ') ;

fn = fopen('car256.txt','r') ;
while ( ~feof(fn))
  fnam = fgetl(fn) 
  aa = imread(fnam) ;
  [mm,nn,kk] = size(aa) ;
  if (kk ~=3 )
    display(['size error: ',fnam]) ;
    system(['del ', fnam]) ;
    continue 
  endif
  aa = imresize(aa,sz) ;
  fnam = ['256_',fnam] ;
  imwrite(aa , fnam) ;
endwhile

fclose(fn) ;
cd F:\imoortant\am_progs ;
return
