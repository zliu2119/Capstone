%
%
[numarr, txtarr] = xlsread("E:\\imoortant\\DATASCIENCE\\acca\\day02_fraud.xlsx") ;
[M,N] = size(txtarr) ;
fnam = "E:\\imoortant\\DATASCIENCE\\acca\\day02_fraud_s.xlsx" ;
return
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

return