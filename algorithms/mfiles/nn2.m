% Generate the matrix of inputs x and targets t.
%
%%
%
clc
close all
clear all
nin=2 ;
nout=1;
ndata=12 ;

x = [ 1 ,0 ; 0, 1 ; 0, 0 ; 1, 1 ] ;
t = [ 1 ; 1 ; 0 ; 0 ] ;
x = [x ; x ; x] ;
t = [ t ; t ; t] ;
%x = rand(12,2) ;
% Set up network parameters.
net = mlp(2, 33, 1, 'logistic');
net.w1
net.w2
net.b1
net.b2
% Set up vector of options for the optimiser.
options = zeros(1,18);
options(1) = 1;			% This provides display of error values.
options(9) = 1;			% Check the gradient calculations.
options(14) = 5000 ;  	% Number of training cycles. 

% Train using scaled conjugate gradients.
[net, options] = netopt(net, options, x, t, 'scg');
net.w1
net.w2
net.b1
net.b2
% Plot the trained network predictions.
x2 = x(1:4,:) ;
y = mlpfwd(net, x2);
figure
plot( y, 'ob')
x2
y
t(1:4)
x2 = [0.0 , 0.9 ; 0.7 , 0.1 ; 0.75 , 0.33 ; 0.1 , 0.2 ; 0.8 , 0.7] ;
y = mlpfwd(net, x2);
figure 
plot( y, 'or')
x2
y


return
