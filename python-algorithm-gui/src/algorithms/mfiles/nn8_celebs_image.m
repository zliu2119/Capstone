% 
% testing ANN classification performance 
% dataset: celebs image
% amir - 2020 
clc
close all
clear all
display('This example shows a perceptron classifier') ;
display('to classify the celebrities into two genders') ;
% Generate the matrix of inputs x and targets t.
dd = csvread("D:\\imoortant\\am_progs\\nice2_deeploc_preproc_tr.csv") ;  
[M,N] = size(dd) ;
prompt = {"Number of training iteration:" , "Number of hidden neurons:"};
rowscols = [ 1,10 ; 1,10 ];

dims = inputdlg (prompt, "Celebrities Classification, Enter the Data", rowscols);
 
itr = str2num( cell2mat(dims(1))) ;
nhid = str2num( cell2mat(dims(2))) ;

feature=dd(:,1:N-2) ;
label=dd(:,N-1) ;
label = (label - 1) ;
[ndata,nin] = size(feature) ;
nout=1 ;

% Set up network parameters.
net = mlp(nin, nhid, nout, 'logistic');

% Set up vector of options for the optimiser.
options = zeros(1,18);
options(1) = 1;			% This provides display of error values.
options(9) = 1;			% Check the gradient calculations.
options(14) = itr ;  	% Number of training cycles. 

% Train using scaled conjugate gradients.
[net, options] = netopt(net, options, feature, label, 'scg');


% Plot the trained network predictions.
tt = csvread("D:\\imoortant\\am_progs\\nice2_deeploc_preproc_tst.csv") ; 
[M1 , N1] = size(tt) ;
x2 = tt(:,1:N1-2)  ;
y2 = tt(:,N1-1) ;
y2 = (y2-1) ;
y = mlpfwd(net, x2);
y=round(y) ;
figure
plot( y, 'ob') ;
hold on ;
plot(y2, '+r') ;
title(' Target (red), and Predicted(blue') ;
zzz = sum( double( y==y2)) ./ M1 ;
printf('\n\n Classification Accuracy = %4.3f\n',zzz) ;

printf('\n MSE = %f\n',mean((y-y2).^2)) ;
return
