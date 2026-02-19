% 
% the 4th ANN example ....
% sin functions estimation
% amir - 2020
%

clear
close all
clc

% Generate the matrix of inputs x and targets t.

x = [-20:0.5:20]';
[ndata,dummy] = size(x) ;

y =  x .^ 3 ; 
y = y ./ max(abs(y)) ;
figure(1) ;
plot(x,y,'r+') ;
 
% Set up network parameters.
net = mlp(1, 5, 1, 'linear');
% pause
% Set up vector of options for the optimiser.
options = zeros(1,18);
options(1) = 1;			% This provides display of error values.
options(9)= 1;			% Check the gradient calculations.
options(14) = 300;		% Number of training cycles. 


% Train using scaled conjugate gradients.
[net, options] = netopt(net, options, x, y, 'scg');
% Plot the trained network predictions.
pv = [-19:0.05:19]';
y2 = mlpfwd(net, pv);
figure(2) 
plot(pv, y2, '.b')
hold on
plot(x,y,'r+') ;
title('red = training , blue = testing samples') ;

return
