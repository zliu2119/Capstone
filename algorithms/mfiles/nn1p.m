% 
% the 1st ANN example ....
% sin functions estimation
% amir - 2020
%

clear
close all
clc

% Generate the matrix of inputs x and targets t.
display('This example shows how a Perceptron Neural Net') ;
display('can interpolate and estimate a function') ;
display('  ') ;
x = [0:1/19:1]';
[ndata,dummy] = size(x) ;

nnopt = {"1- Sine ", "2- Sine plus noise", "3- Sine plus powerful noise"};
[sel1, ok1] = listdlg ("ListString", nnopt, "SelectionMode", "Single", ...
"ListSize",[400,300], "PromptString" , " Select Your Function " , "Name" , "ANN Function Estimator");
if (ok1 == 1)
 switch (sel1) 
      case (1)
        t = sin(2*pi*x) ;
      case (2)
        t = sin(2*pi*x)  + 0.05*randn(ndata, 1);
      case (3) 
        t = sin(2*pi*x)  + 0.5*randn(ndata, 1);  
 endswitch
else
  return;
endif

figure ;
plot(x,t,'r+') ;
title('Function to be estimated, red+ = data samples') ;

prompt = {"number of hidden layer nodes", "Training epochs"};
rowscols = [1,10; 1,10 ];

dims = inputdlg (prompt, "Enter Data", rowscols);
hnode = str2num( cell2mat(dims(1))) ;
epch = str2num( cell2mat(dims(2))) ;

% Set up network parameters.
net = mlp(1, hnode, 1, 'linear');
% pause
% Set up vector of options for the optimiser.
options = zeros(1,18);
options(1) = 1;			% This provides display of error values.
options(9)= 1;			% Check the gradient calculations.
options(14) = epch;		% Number of training cycles. 


% Train using scaled conjugate gradients.
[net, options] = netopt(net, options, x, t, 'scg');
% Plot the trained network predictions.
pv = [0:0.005:1]';
y = mlpfwd(net, pv);
figure 
plot(pv, y, '.b')
hold on
plot(x,t,'r+') ;
title('red = training , blue = testing samples') ;

return
