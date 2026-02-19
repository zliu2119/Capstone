%
%
%

[numarr, txtarr] = xlsread("1234.xlsx") ;
[M,N] = size(numarr) ;
fnam = "1234out.txt" ;
fp1 = fopen(fnam,'w+') ;
i=1 ;
while (i<M-20)
  fprintf(fp1, "%d \t %d \t %d \t %s\n" , numarr(i,1),numarr(i,2), numarr(i,4), cell2mat(txtarr(i)) ) ; 
  printf("%d \t %d \t %d \t %s\n" , numarr(i,1),numarr(i,2), numarr(i,4), cell2mat(txtarr(i)) ) ; 
  i
  j=i+1 ;
  while( numarr(i,2) == numarr(j,2) )
    j = j + 1 ;
  endwhile
  i=j ;
endwhile

fclose(fp1) ;

return  
