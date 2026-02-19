% 
% data1 example
% amir 2020

close all
clear all
clc

a= csvread('celebs2.csv') ;
titrs = { 'height' , 'weight' , 'gender' } ;
for i=1:3
  subplot(2,3,i) , plot( a(:,i)) , title(titrs(i) ) ;
  subplot(2,3,i+3) , bar( a(:,i)) , title(titrs(i) ) ;
endfor

figure ;
for i=1:3
  subplot(2,3,i) , hist( a(:,i)) , title(titrs(i) ) ;
  subplot(2,3,i+3) , hist( a(:,i),5) , title(titrs(i) ) ;
endfor

figure ;
subplot(1,2,1) , scatter( a(:,1) , a(:,2) , 'r') , title('scatter plot') , ... 
                 xlabel(titrs(1) ) , ylabel(titrs(2)) ;
subplot(1,2,2) , scatter( a(:,1) , a(:,2) ,[] , a(:,3) , 'filled') , title('scatter plot- Gender') , ... 
                 xlabel(titrs(1) ) , ylabel(titrs(2)) ;
          
figure ;
subplot(1,2,1) , ... 
scatter3(a(:,1) , a(:,2) , a(:,3)) , xlabel(titrs(1) ) , ylabel(titrs(2)) , zlabel(titrs(3)) ;
subplot(1,2,2) , colormap(summer) , ... 
scatter3(a(:,1) , a(:,2) , a(:,3) , [] , a(:,1)), xlabel(titrs(1) ) , ylabel(titrs(2)) , zlabel(titrs(3)) ;

figure ;
subplot(1,2,1) , boxplot (a(:,1), 0); , title('Box Plot, Height') ;
subplot(1,2,2) , boxplot (a(:,2), 0); , title('Box Plot, Weight') ;

fprintf('\n\n\tHeight\t\t Weight\n') ;
fprintf('Average  %8.4f \t %8.4f\n' , mean(a(:,1)) , mean(a(:,2)) ) ;
fprintf('STD \t %8.4f \t %8.4f\n' , std(a(:,1)) , std(a(:,2)) ) ;
fprintf('Max \t %8.4f \t %8.4f\n' , max(a(:,1)) , max(a(:,2)) ) ;
fprintf('Min \t %8.4f \t %8.4f\n' , min(a(:,1)) , min(a(:,2)) ) ;

return
