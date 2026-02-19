%--------------------
% TEST KNN 3
% Gender Detection based on  images ....
%--------------------
clc
clear all
close all
display("This example shows the KNN to classify the");
display(" celebrities into genders using their photos") ;
prompt = {"Smaller(1) or Bigger(2) dataset?", "Number of Neighbors (k):" };
rowscols = [1,10 ; 1,10 ];

dims = inputdlg (prompt, "KNN Classification, Celebs Photos, Enter the Data", rowscols);
dbs = str2num( cell2mat(dims(1))) ;
kk = str2num( cell2mat(dims(2))) ;
if (dbs !=1)
  dataset = csvread('nice_incept3p_tr.csv') ;
  hw = csvread('nice_incept3p_tst.csv') ;
else
  dataset = csvread('nice_smaller_incept3_tr.csv') ;
  hw = csvread('nice_smaller_incept3_tst.csv') ;
endif
[M1,N1] = size(dataset) ;
[M,N] = size(hw) ;
printf('\n Training Dataset Size = %dx%d \n Test Dataset Size = %dx%d \n\n',M1,N1,M,N) ;
% lousy mapping
gender = [ 'woman' ; 'man  ' ]; 

%% ---------------------
%% TEST ....
%% ---------------------

lab = hw(:,N) ;
hw = hw(:,1:N-1) ;

cnt=0 ;
for i=1:M
  fast_knn(dataset, hw(i,:), kk) ;
  zz = gender(ans+1,:) ;
  printf(' Predicted Gender = %s \t\t True Gender= %s\n',zz , gender(lab(i)+1,:) ) ;
  if( ans==lab(i))
    cnt = cnt + 1;
  endif

endfor
printf( "\nnumber of correct classification %d   out of %d  using %d neighbors\n",cnt,M,kk) ;
printf( "accuracy = %5.2f%%\n", cnt/M*100) ;

return
