
clear all
clc
close all

fhnd = fopen('lst.txt') ;
fnin = fgetl(fhnd) ;
while( size(fnin) ~= 0 )
  printf('processing : %s\n' , fnin ) ;
  dot = strfind(fnin,'.') ;
  fnout = fnin(1:dot-1) ;

  fnout = ['weap\' , fnout] ;

  x = VideoReader (fnin);
  zzt = x.NumberOfFrames ;
  for i=1:zzt-1
    img = readFrame(x) ;
    if (i>=min(80,zzt) && mod(i,20)==0)
      fnout2 = [fnout , '_' , num2str(i) , '.png'] ;
      imwrite(img , fnout2 , 'png') ;
    endif
  endfor
  fnin = fgetl(fhnd);
endwhile

fclose(fhnd)
return
