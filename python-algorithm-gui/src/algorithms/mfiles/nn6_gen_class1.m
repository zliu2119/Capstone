% 
% testing ANN classification performance 
% general classification
% conditions: 1- single .csv or .xls/xlsx data file; 2- output class in last col and [0,1]
% 3- # features and # samples are up to you but dont make them that big
%
% amir - 2021
%
clc
close all
clear all
display('This example shows a perceptron classifier') ;
display('to classify any dataset') ;

prompt = { "Dataset File:" , "Training Set Percentage(50-99):" , "Number of hidden neurons:", ...
    "Number of training iterations:", "Filter these Features: (Separate with <,>)" , "Normalization? (y/n)" , ... 
    "Feature Visualization? (y/n)", "Showing Training Errors? (y/n)" };
rowscols = [1,25 ; 1,8 ; 1,8; 1,8; 1,8; 1,8 ; 1,8 ; 1,8];

dims = inputdlg (prompt, "Classification Test, Enter the Data", rowscols);
fnam = cell2mat(dims(1)) ;
TRP = str2num( cell2mat(dims(2))) ;
nhid = str2num( cell2mat(dims(3))) ;
itr = str2num( cell2mat(dims(4))) ;
igfeat = cell2mat(dims(5)) ;
norm_sw = cell2mat(dims(6)) ;
vis_sw = cell2mat(dims(7)) ;
err_sw = cell2mat(dims(8)) ;

fnam = toupper(fnam) ;
if ( prod(size(strfind(fnam,"XLS"))) ~= 0)
  [dd,alaki] = xlsread(fnam) ;
else
  dd = csvread(fnam) ;
endif

%check filtering features
if (prod(size(igfeat)) ~= 0)
  igfeat = str2num(igfeat) ;
  dd = ignore_feat(dd,igfeat) ;
endif

% check the normalization 
if toupper(norm_sw) == 'Y'

  nr_options = {"1-Uniform Normalization", "2-Gaussian Normalization" };
  [nrsel,ok] = listdlg ("ListString", nr_options, "SelectionMode", "Single", "ListSize",[250,100], "PromptString" ,...
  " Select Your Normalization Alg " , "Name" , "Normalization") ;
  if (ok == 1)
    switch (nrsel) 
      case (1)
        [dd,nrcoef] = am_norm_feature_uni(dd,1) ;
      case (2)
        [dd,nrmu,nrstd] = am_norm_feature_gu(dd,1) ;
    endswitch
  else
    disp ("No Normalization would be done");
  endif
  
endif

[M,N] = size(dd) ;

%% visulization
if (toupper(vis_sw)=="Y")
  figure(1) ;
  scatter3(dd(:,1) , dd(:,2) , dd(:,N) , [] , dd(:,N)), ... 
  xlabel('feature 1' ) , ylabel('feature 2') , zlabel('class') , title('class');
  if (N>4)
    figure(2) ;
    scatter3(dd(:,3) , dd(:,4) , dd(:,N) , [] , dd(:,N)), ... 
    xlabel('feature 3' ) , ylabel('feature 4') , zlabel('class') , title('class');
  endif
endif

% == Building train and test sets
%
TSTP = M - round (TRP/100*M) ;
border = randi(round(M/2)-2) ;
x_tst = dd(border:border+TSTP,1:N-1) ;
y_tst = dd(border:border+TSTP,N) ;

x_tr = dd(1:border-1,1:N-1) ;
y_tr = dd(1:border-1,N) ;

x_tr = [x_tr ; dd(border+TSTP+1:M,1:N-1) ] ;
y_tr = [y_tr ; dd(border+TSTP+1:M,N) ] ;

% -- showing 
printf("\n\nSituation: \n File: %s \n No of Samples= %d \n No of Features=%d\n", fnam, M , N-1) ;
printf(" Training set size = %d * %d \n",size(x_tr) ) ;
printf(" Testing set size = %d * %d \n\n",size(x_tst) ) ;

% Set up network parameters.
net = mlp(N-1, nhid, 1, 'logistic');

% Set up vector of options for the optimiser.
options = zeros(1,18);
if ((toupper(err_sw))=="Y")
  options(1) = 1;			% This provides display of error values.
endif
options(14) = itr ;  	% Number of training cycles. 
options(9) = 1 ;			% Check the gradient calculations.

% Train using scaled conjugate gradients.
[net, options] = netopt(net, options, x_tr , y_tr, 'scg');

% Plot the trained network predictions.
[MM,NN] = size(x_tst) ;
y = mlpfwd(net, x_tst);
yr=round(y) ;
figure(5) ;
plot( yr, 'ob') ;
hold on ;
plot(y_tst, '+r') ;
title(' Target (red), and Predicted(blue') ;
zzz = sum( double( yr==y_tst)) / (MM) ;

printf('\n\n Classification Accuracy = %5.3f',zzz) ;
printf('\n MSE (before rounding)= %f',mean((y-y_tst).^2)) ;
printf('\n MSE (after rounding) = %f\n\n',mean((yr-y_tst).^2)) ;

return
