% 
% testing ANN classification performance 
% dataset: HDB houses price,  2 classes
% amir - 2019 
clc
close all
clear all
display('This example shows a perceptron classifier') ;
display('to classify the HBD apartments into 2 classes.') ;
% Generate the matrix of inputs x and targets t.
X = csvread('resale19_noheader.csv') ;
prompt = {"Training Set Percentage(1%-100%):", "Number of training iteration:" , "Number of hidden neurons:"};
rowscols = [1,12; 1,12 ; 1,12 ];

dims = inputdlg (prompt, "HDB Classification, Enter the parameters", rowscols);
TRP = str2num( cell2mat(dims(1))) ;
itr = str2num( cell2mat(dims(2))) ;
nhid = str2num( cell2mat(dims(3))) ;
[M,dummy] = size(X) ;

%% visulization
figure(1) ;
scatter3(X(:,3) , X(:,5) , X(:,6) , [] , X(:,6)), ... 
xlabel('area' ) , ylabel('year') , zlabel('class') , title('classes') ;

TRP = round (TRP/100*M) ;

feature=X(1:TRP,1:5) ;
label= X(1:TRP,6) ;
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
x2 = X(TRP+1:M,1:5) ;
y2 = X(TRP+1:M,6) ;
y = mlpfwd(net, x2) ;
figure(2) ;
plot( y, 'ob') ;
hold on ;
plot(y2, '+r') ;
title(' Target (red), and Predicted(blue') ;
zzz = sum( double( round(y)==y2)) / (M-TRP) ;
printf('\n\n Classification Accuracy = %4.3f\n',zzz) ;

printf('\n\n MSE = %f\n',my_mse(y,y2)) ;
return
