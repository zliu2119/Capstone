%
% Genetic algorithm to solve travelling salesman problem
% data file: distances_128.xlsx , contains distances between 128 US cities
% 
% amir - 2020
% ------------------------------------------------

clc
close all
clear all

display('This example shows how Genetic Algorithm can be used to solve the TSM problem.');
prompt = {"How many Towns?", "Population size?" , "No of iterations?" , "Mutation rate? (0 -1)" ... 
          , "Cloning best chromosomes? (y/n)", "Show the final fitness? (y/n)"};
rowscols = [1,10; 1,10 ; 1,10 ; 1,10 ; 1,10 ; 1,10];

dims = inputdlg (prompt, "TSM Solver!! Enter the GA Data", rowscols);
N = str2num( cell2mat(dims(1))) ;
M = str2num( cell2mat(dims(2))) ;
cnd = str2num( cell2mat(dims(3))) ;
mut = str2num( cell2mat(dims(4))) ; 
cl_sw =  toupper( cell2mat( dims(5) )) ;
show_sw = toupper( cell2mat( dims(6) ));

%% to save the found min distance path ...
min_rep = { 0 , 999999999 , zeros(1,N) , 1} ;

[rdata, namdata] = xlsread('distances_128.xlsx') ;
namdata = namdata(3:end,1)  ;
rdata = rdata(1:N-1,1:N-1) ;
pup = build_pup_tsm(N,M) ;
fn_array = fitness_tsm1(pup,rdata) ;
if (cl_sw == "Y")
    [best_ch , best_ftn] = sav_best_ch(pup , fn_array) ;
endif

[f_min , m_ind] = min(fn_array) ;
if (f_min < min_rep{2})
  min_rep{2} = f_min ;
  min_rep{1} = m_ind ;
  min_rep{3} = pup(m_ind,:) ;
endif

figure(2) ;
fct = 250 / max(max(abs(pup))) ;
subplot(1,4,1) , imshow(uint8(pup(1:50,:) .* fct)) , title('Initial Population') ;
fct = 250 / max(abs(fn_array)) ;
subplot(1,4,2) , imshow(uint8(fn_array(1:50,:) .* fct)) , title('initial Fitness') ;

minfitn = [ min(fn_array) ] ;
avgfitn=[mean(fn_array)] ;
figure(1) ;
plot(minfitn , 'r') ;
hold on ;
plot(avgfitn , 'b') ;

for ii=1:cnd
  pup = tsm_next_gen(pup,fn_array) ;
  if (mut ~=0)
    pup = tsm_mutation(pup,mut) ;
  endif
  fn_array = fitness_tsm1(pup,rdata) ; 
  if (cl_sw == "Y")
    [pup , fn_array] = rep_best_ch(best_ch , best_ftn , pup , fn_array) ;
    [best_ch , best_ftn] = sav_best_ch(pup , fn_array) ;
  endif
  [f_min , m_ind] = min(fn_array) ;
  if (f_min < min_rep{2})
    min_rep{2} = f_min ;
    min_rep{1} = m_ind ;
    min_rep{3} = pup(m_ind,:) ;
    min_rep{4} = ii ;
  endif
  minfitn = [ minfitn , min(fn_array) ] ;
  avgfitn = [ avgfitn , mean(fn_array)] ;
  figure(1) ;
  plot(minfitn , 'r') ;
  hold on ;
  plot(avgfitn , 'b') ;
  title('Minimum (red) and Average (blue) Fitness') ;
  
  printf("\n iterration=%5d, minimum distance=%8d, average distance=%f",ii,min(fn_array),mean(fn_array) );
endfor

printf("\n\n") ;
figure(2) ;
fct = 250 / max(max(abs(pup))) ;
subplot(1,4,3) , imshow(uint8(pup(1:50,:) .* fct)) , title('Final Population') ;
fct = 250 / max(abs(fn_array)) ;
subplot(1,4,4) , imshow(uint8(fn_array(1:50,:) .* fct)) , title('Final Fitness') ;
if (show_sw=="Y")
  display('The final fitness array: ') ;
  fn_array
endif

[mnx, mnid] = min(fn_array) ;

printf('\n\n======================================\n') ;
printf('\nThe Last generation results:\n') ;
printf('\n Last Gen minimum distance = %d  , at chromosome #%d, average distance=%f\n\n', mnx,mnid,mean(fn_array) ) ; 
printf('Last Gen Minimum distance path:\n' ) ; 
printf('%d\t' , pup(mnid,:) ) 
pt_str = traced_path( namdata , pup(mnid,:) ) ;
printf('\n\n Last Gen Minimum distance path: %s\n',pt_str) ; 

printf('\n\n\n-------------------------\n THE BEST RESULTS\n minimum distance = %d  , at generation #%d, \n\n', ...
      min_rep{2} , min_rep{4} ) ; 
printf('The minimum distance path:\n' ) ; 
printf('%d\t' , min_rep{3})
pt_str = traced_path( namdata , min_rep{3} ) ;
printf('\n\n Minimum distance path: %s\n',pt_str) ; 
printf('\n\n TSM Status: #Cities= %4d , Population Size=%6d , # Regeneration=%5d , Mutation Rate=%6.3f' , ...
      N, M, cnd, mut) ;
printf('\n\n\n') ;


return
