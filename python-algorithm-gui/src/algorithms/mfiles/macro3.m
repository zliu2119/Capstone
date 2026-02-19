%
% macro 3 - list -
%
close all
clear all
clc

fid = fopen ("lst.txt");
imfnam = fgetl(fid)
while imfnam ~= -1
  a = imread(imfnam) ;
  a = 255 - a ;
  [mm,nn,kk] = size(a) ;
  a = noise2(a,0.01) ;
  if kk==3
    a = color_swap(a) ;
  endif

  imfnam22 = ['t2_',imfnam] ;
  imwrite(a, imfnam22) ;
  imfnam = fgetl(fid)

endwhile

fclose (fid);
display('\n\nbye......\n\n') ;
return
