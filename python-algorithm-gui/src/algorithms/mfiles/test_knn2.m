%--------------------
% TEST KNN 2
% Gender Detection ....
%--------------------
clc
clear all
close all

dataset = csvread('celebs2.csv') ;

% lousy mapping
gender = [ 'woman' ; 'man  ' ]; 


%% ---------------------
%% TEST ....
%% ---------------------
prompt = {"Number of Neighbors? ", "Height ? (cm)", "Weight ? (kg)"};
rowscols = [1,10; 1,10 ; 1,10];
hw=zeros(1,2) ;
dims = inputdlg (prompt, "KNN Test, Celebrities Gender, Based on Height and Weight", rowscols);
kk =  str2num(cell2mat(dims(1))) ;
hw(1) =  str2num(cell2mat(dims(2))) ;
hw(2) =  str2num(cell2mat(dims(3))) ;
fast_knn(dataset, hw,kk) ;
zz = gender(ans,:) ;
printf('k=%d , Height=%6.2f , Weight=%6.2f ==> Gender = %s\n\n',kk,hw,zz ) ;
h = msgbox ( ['k= ',num2str(kk),' , Height= ' , num2str(hw(1)) , ', Weight= ', num2str(hw(2)),'  ==> Gender =',zz], "KNN Result") ;
return
