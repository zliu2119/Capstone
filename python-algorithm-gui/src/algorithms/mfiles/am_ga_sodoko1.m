%
% Genetic algorithm to solve sudoku puzzle
% amir - 2020
% ------------------------------------------------

clc
close all
clear all

N= 9 ;
M= 2000 ;
%% pup = randi(N,M,N*N) ;
load pup020520 ;
cnd= 600 ;
mut= 0.2 ;

fn_array = compute_fitness_sudoku(pup) ;

figure(2) ;
subplot(1,4,1) , imshow(uint8(pup .* 10)) ;
subplot(1,4,2) , imshow(uint8(fn_array .* 10)) ;

minfitn = [ min(fn_array) ] ;
avgfitn=[mean(fn_array)] ;
figure(1) ;
plot(minfitn , 'ro') ;
hold on ;
plot(avgfitn , 'b*') ;

while (cnd>0 && minfitn>0)
  pup = next_gen(pup,fn_array) ;
  pup = mutation_sudoku(pup,mut,N) ;
  size(pup)
  fn_array = compute_fitness_sudoku(pup) ; 
  minfitn = [ minfitn , min(fn_array) ] ;
  avgfitn = [ avgfitn , mean(fn_array)] ;
  figure(1) ;
  plot(minfitn , 'ro') ;
  hold on ;
  plot(avgfitn , 'b*') ;
  
  cnd = cnd - 1 
endwhile

figure(2) 
subplot(1,4,3) , imshow(uint8(fn_array .* 10)) ;
subplot(1,4,4) , imshow(uint8(pup .* 10)) ;
display('The final fitness array') ;
fn_array

[mnx, mnid] = min(fn_array) ;
printf('\n minimum/lowest fitness = %d  , at %d, average fitness=%f\n\n', mnx,mnid,mean(fn_array) ) ; 
reshape( pup(mnid,:),N,N)  


return
