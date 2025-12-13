%
% Genetic algorithm to solve n-queens problem
% amir - 2019
% revised March 2021
% ------------------------------------------------

clc
close all force
clear all

msgbox ('This example shows how Genetic Algorithm can be used \n to solve the n-Queens problem.');
prompt = {"How many Queens?", "Population size?" , "No of iterations?" , "Mutation rate? (0 to 1)" , ...
 "Printing the Fitness? (y/n)"};
rowscols = [1,10; 1,10 ; 1,10 ; 1,10 ; 1,10];

dims = inputdlg (prompt, "N-Queens!! Enter the GA Data", rowscols);
N = str2num( cell2mat(dims(1))) ;
M = str2num( cell2mat(dims(2))) ;
cnd = str2num( cell2mat(dims(3))) ;
mut = str2num( cell2mat(dims(4))) ;
prsw = cell2mat(dims(5)) ;

pup = randi(N,M,N) ;
fn_array = compute_fitness(pup,prsw) ;
lev2 = min(50,M) ;

figure(2) ;
subplot(1,4,1) , imshow(uint8(pup(1:lev2,:) .* 10)) ;
subplot(1,4,2) , imshow(uint8(fn_array(1:lev2,:) .* 10)) ;

minfitn = [ min(fn_array) ] ;
avgfitn=[mean(fn_array)] ;
figure(1) ;
plot(minfitn , 'ro') ;
hold on ;
plot(avgfitn , 'b*') ;

ii=1 ;
while (cnd>0 && minfitn>0)
  pup = next_gen(pup,fn_array) ;
  pup = mutation(pup,mut) ;
  size(pup) ;
  fn_array = compute_fitness(pup , prsw) ;
  minfitn = [ minfitn , min(fn_array) ] ;
  avgfitn = [ avgfitn , mean(fn_array)] ;
  figure(1) ;
  plot(minfitn , 'ro') ;
  hold on ;
  plot(avgfitn , 'b*') ;
  title('Minimum (red) and Average (blue) Fitness') ;
  cnd = cnd - 1 ;
  printf('\n Generation = %d\n' , ii++) ;
endwhile

figure(2)
title('Population (columns 1,4 from left) and Fitness (2,3), initial (1,2) and final (3,4)') ;
subplot(1,4,3) , imshow(uint8(fn_array(1:lev2,:) .* 10)) ;
subplot(1,4,4) , imshow(uint8(pup(1:lev2,:) .* 10)) ;
if toupper(prsw)=='Y'
  display('The final fitness array') ;
  fn_array
endif
[mnx, mnid] = min(fn_array) ;
printf('\nBest/Minimum Fitness= %d, at row %d,\t Average fitness= %f\n', mnx,mnid,mean(fn_array) ) ;
printf('No of Queens= %d,\tPopulation Size= %d,\tMutation Rate= %6.4f\n\n', N,M,mut) ;
pup(mnid,:)

answer = zeros(N,N) ;
for j=1:N
      answer(pup(mnid,j),j) = 1  ;
endfor
figure('name','Final Answer')
imshow( uint8(answer .* 200) ) ;

answer = num2str(answer) ;
msgbox ( answer , 'ANSWER: ' );

return
