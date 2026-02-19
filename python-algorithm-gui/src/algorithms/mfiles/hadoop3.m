% ---------------------
% Hadoop Simulator
% amir - 2021
% ----------------------
%
clc
close all
clear all

my_options = {"Big Data/ Hadoop Style Image Filtering", "Big Data/ Hadoop Style Data Processing" };
OK = 1 ;
while( OK==1)
  [SEL, OK] = listdlg ("ListString", my_options, "SelectionMode", "Single", "ListSize",[400,300], "PromptString" ,...
  " Select Your Program " , "Name" , "Big Data Processing System") ;          
  
  if (OK == 1)
    prompt1 = {"Number of Nodes: (between 3 and 5)"}; 
    rowscols1 = [1,10] ;
    dims1 = inputdlg (prompt1, "Hadoop Simulator, Setting", rowscols1);
    if (length(dims1) != 0)
      N =  str2num( cell2mat( dims1(1) ) ) 
    else
      N = 3 ;
    endif
    disp (sprintf ("\t%s", my_options{SEL}));
    save TMP111
    close all
    clc
    switch (SEL) 
      case (1)
        a = imread('Roofs1.jpg') ;
        manfi4(a,N) ;
      case (2)
        manfi44(N) ;
    endswitch
    pause(40) ;
    load TMP111
  else
    disp ("You cancelled.");
  endif

endwhile

close all ;
clear all ;

return
