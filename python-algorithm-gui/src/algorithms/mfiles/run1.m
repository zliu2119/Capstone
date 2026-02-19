% ---------------------
% batch running SCALE Octave programs
% amir - 2020
% v2 - 2021, added items and auto installation/loading of packs
% ----------------------
clc
close all force
clear all

prompt = {"Do you need packages to be installed? (y/n)", "Do you need packages to be loaded? (y/n)"};
rowscols = [1,10; 1,10 ];


dims = inputdlg (prompt, "NUS-SoC AI System, PACKAGES INSTALLATION", rowscols);

if (length(dims) != 0)
  pkg_inst =  cell2mat(dims(1)) ;
  pkg_load =  cell2mat(dims(2)) ;
  if (toupper(pkg_inst)=="Y")
    pkg install -forge  image
    pkg install -forge  io
    pkg install -forge  statistics
  endif
  if (toupper(pkg_load)=="Y")
    pkg load  image
    pkg load  io
    pkg load  statistics
  endif
endif

my_path ;

my_options = {" 1-Fuzzy Logic: Car Brake", " 2-Fuzzy Logic2: Car Brake, Advanced", " 3-Genetic Algorithm: n-Queens", ...
" 4-Genetic Algorithm: Traveling Salesman" , ...
" 5-KNN Test 1: Fruits" , " 6-KNN Test 2: Celebrity's Gender, H&W Data" , " 7-KNN Test 3: Celebrity's Gender, Images" , ...
" 8-ANN Example 1: Function Estimation" , " 9-ANN Example 2: HDB Classification" ,"10-ANN Example 3: Calculator", ...
"11-ANN Example 4: General Classifier" , "12- ANN Example 5: General Function Estimator" , ...
"13-Hash Function" , "14-Bitcoin Decryption" , "15-Correlation Function" , "16-Guassian Distribution", ...
"17-Linear Regression" , "18-Logic and Decision Making" };

OK = 1 ;
while( OK==1)
  [SEL, OK] = listdlg ("ListString", my_options, "SelectionMode", "Single", "ListSize",[420,420], "PromptString" ,...
  " Select Your Program " , "Name" , "NUS-SoC AI System") ;
  if (OK == 1)
    disp (sprintf ("\t%s", my_options{SEL}));
    save TMP1
    switch (SEL)
      case (1)
        fuzzy_test1 ;
      case (2)
        fuzzy_test2p ;
      case (3)
        am_ga1 ;
      case (4)
        am_ga2 ;
      case (5)
        test_knn ;
      case (6)
        test_knn2 ;
      case (7)
        test_knn3 ;
      case (8)
        nn1p ;
      case (9)
        nn6_resale1p ;
      case (10)
        nn7_as ;
      case (11)
        nn6_gen_class1 ;
      case (12)
        nn6_gen_est1 ;
      case (13)
        am_hash1 ;
      case (14)
        am_hash2 ;
      case (15)
        am_corr1 ;
      case (16)
        guasstest ;
      case (17)
        lrg11 ;
      case (18)
        am_logic3 ;
    endswitch
    load TMP1
    pause(20)
  else
    disp ("You cancelled.");
  endif

endwhile

return
