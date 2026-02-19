% ---------------------
% batch running SCALE Octave programs
% amir - 2020
% ----------------------
clc
close all
clear all
my_path ;
my_options = {"Big Data/ Hadoop Style Image Filtering", "Big Data/ Hadoop Style Data Processing" };
OK = 1 ;
while( OK==1)
  [SEL, OK] = listdlg ("ListString", my_options, "SelectionMode", "Single", "ListSize",[400,300], "PromptString" ,...
  " Select Your Program " , "Name" , "Big Data System") ;          
  if (OK == 1)
    disp (sprintf ("\t%s", my_options{SEL}));
    save TMP1
    close all
    clc
    switch (SEL) 
      case (1)
        a = imread('Roofs1.jpg') ;
        manfi(a) ;
      case (2)
        manfi2() ;
    endswitch
    pause(40) ;
    load TMP1
  else
    disp ("You cancelled.");
  endif

endwhile

close all ;
clear all ;

return
