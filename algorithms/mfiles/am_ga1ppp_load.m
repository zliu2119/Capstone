%
% Genetic algorithm to solve n-queens problem
% amir - 2019
% revised March 2021
% added: dynamic mutation , cloning
% Dec 2023, amir%
% ------------------------------------------------

clc
close all force
clear all

prompt = {"Load from ?" , "No of iterations?" };
rowscols = [1,10; 1,10 ] ;

dims = inputdlg (prompt, "N-Queens!! Enter the GA Data", rowscols);
cnd2 = str2num( cell2mat(dims(2))) ;
ldfile = cell2mat(dims(1)) ;
ldfile = ['load ', ldfile] ;
eval(ldfile) ;

cnd = cnd2 ;
ii=1 ;
while (cnd>0 && minfitn>0)
  % coloning 1 ...............
  [mn,mnn] = min(fn_array) ;
  mnn2 = pup(mnn,:) ;
  pup = next_gen(pup,fn_array) ;
  pup = mutation(pup,mut) ;
  fn_array = compute_fitness(pup , prsw) ;
  % coloning 2.....
  [mx,mxx] = max(fn_array) ;
  pup(mxx,:) = mnn2 ;
  fn_array = compute_fitness(pup , prsw) ;
  minfitn = [ minfitn , min(fn_array) ] ;
  avgfitn = [ avgfitn , mean(fn_array)] ;
  figure(1) ;
  plot(minfitn , 'r.') ;
  hold on ;
  plot(avgfitn , 'b.') ;
  title('Minimum (red) and Average (blue) Fitness') ;
  cnd = cnd - 1 ;
  printf('\n Generation = %d \t best fitness= %d' , ii++ , min(fn_array) ) ;
  if toupper( dmr ) =='Y'    % dynamic mutaton rate would be applied
    new_std = std(fn_array) ;
    if (new_std < pstdfct * org_std)
      if toupper( mutbg1 ) ~='Y'
        mut = min( 1, mut * muifct) ;
      else
        mut = mut * muifct ;
      endif
      printf('\n   Mutation rate increased to %6.4f',mut) ;
    endif
  endif


endwhile

figure(2)
title('\nPopulation (columns 1,4 from left) and Fitness (2,3), initial (1,2) and final (3,4)') ;
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
msgbox (answer , 'ANSWER: ');

return
