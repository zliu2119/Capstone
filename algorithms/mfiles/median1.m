%
%
%
cd C:\Users\sleam\Desktop\Gan_faces_results\cars
fnam1 = input('File Name >','s') ;
pkg load image ;
fid = fopen (fnam1, 'r') ;

while (! feof (fid) )
  fnam2 = fgetl (fid)
  a = imread(fnam2) ;
  b = am_median_filt(a,5) ; 
  b = uint8(b) ;
  imwrite( b , ['m2_' , fnam2] ) ;
  b = am_median_filt(a,7) ;
  b = uint8(b) ;
  imwrite( b , ['m3_' , fnam2] ) ;
endwhile

fclose (fid);
return

