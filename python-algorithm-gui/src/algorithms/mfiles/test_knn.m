%--------------------
% TEST KNN 1
% fruits, banana or apple? 
%--------------------

clc ;
close all ;

dataset = [
  %weight, color, # seeds, type
  303,     3,      1, 1;
  370,     1,      2, 2;
  298,     3,      1, 1;
  277,     3,      1, 1;
  377,     4,      2, 2;
  299,     3,      1, 1;
  382,     1,      2, 2;
  374,     4,      6, 2;
  303,     4,      1, 1;
  309,     3,      1, 1;
  359,     1,      2, 2;
  366,     1,      4, 2;
  311,     3,      1, 1;
  302,     3,      1, 1;
  373,     4,      4, 2;
  305,     3,      1, 1;
  371,     3,      6, 2;
];

% lousy mapping
fruit = {'Banana', 'Apple'}; 
color.index = {'red', 'orange', 'yellow', 'green', 'blue', 'purple'};
color.red       = 1;
color.orange    = 2;
color.yellow    = 3;
color.green     = 4;
color.blue      = 5;
color.purple    = 6;

UF1 = [301, color.green, 1]
UF2 = [346, color.yellow, 1]
UF3 = [290, color.red, 1] 

%% ---------------------
%% TEST ....

fast_knn(dataset, UF1)
fruit(ans)

fast_knn(dataset, UF2)
fruit(ans)

fast_knn(dataset, UF3)
fruit(ans)

return
