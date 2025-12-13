%
%
%
clear all
clc
[aa , bb] = xlsread("F:\\imoortant\\am_progs\\aviation\\tweets3.xlsx") ;
[mm,nn] = size(bb)

for i=1:mm
  bb(i,5) = strrep (bb(i,5), '@', '__') ;
  bb(i,5) = strrep (bb(i,5), ',', ';') ;
  i
endfor
  

myf = fopen ("F:\\imoortant\\am_progs\\aviation\\ttmmpp.txt", "w"); 
for i=1:mm
  for j=1:nn 
    fprintf(myf,'%s  ,  ' , cell2mat(bb(i,j)) ) ;
  endfor
  fprintf(myf,'\n') ;
  i
endfor

return 