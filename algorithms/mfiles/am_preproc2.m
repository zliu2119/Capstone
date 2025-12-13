%
%
%
cd  C:\Users\sleam\Desktop\caartmp\car_side_2104_preproc\tmp

fn = fopen('cars.txt','r') ;
while ( ~feof(fn))
  fnam = fgetl(fn) 
  aa = imread(fnam) ;
  [mm,nn,kk] = size(aa) ;
  if (kk ~=3 )
    display(['size error: ',fnam]) ;
    system(['del ', fnam]) ;
    continue 
  endif
  aa = fliplr(aa) ;
  imwrite(aa , fnam) ;
endwhile

fclose(fn) ;
cd F:\imoortant\am_progs ;
return
