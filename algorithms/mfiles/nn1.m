% 
% the 1st ANN example ....
% sin functions estimation
% amir - 2006
%

clear
close all
clc

% Generate the matrix of inputs x and targets t.
display('This example shows how a Perceptron Neural Net') ;
display('can interpolate and estimate a function') ;
display('  ') ;
wfun = input('Select the Function 2b estimated: 1- Sine   , 2-Sine+noise > ') ;
if (wfun == 2)
  nlev = input('Noise strength: 1-Low  , 2-High > ') ;
  nlev = nlev ^ 2 ;
endif

x = [0:1/19:1]';
[ndata,dummy] = size(x) ;
if (wfun==1)
  t = sin(2*pi*x) ;
else
  t = sin(2*pi*x)  + 0.05*nlev*randn(ndata, 1);
endif

hnode = input('number of hidden layer nodes > ') ;
epch = input('Training epochs > ') ;

% Set up network parameters.
net = mlp(1, hnode, 1, 'linear');
% pause
% Set up vector of options for the optimiser.
options = zeros(1,18);
options(1) = 1;			% This provides display of error values.
options(9)= 1;			% Check the gradient calculations.
options(14) = epch;		% Number of training cycles. 


% Train using scaled conjugate gradients.
options
net
[net, options] = netopt(net, options, x, t, 'scg');
options
net
% Plot the trained network predictions.
pv = [0:0.005:1]';
y = mlpfwd(net, pv);
figure 
plot(pv, y, '.b')
hold on
plot(x,t,'r+') ;


return
