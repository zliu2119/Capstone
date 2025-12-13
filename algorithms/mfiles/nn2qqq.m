% Generate the matrix of inputs x and targets t.
%
%%
%
clc
close all
clear all
nin=2 ;
nout=1;

load celebs2 ;
x = celebs2_tr(:,1:2) ;
t = celebs2_tr(:,3) ;
t=t-1 ;
[ndata,vv] = size(x) ;
 
x2 = celebs2_tst(:,1:2) ;
y2 = celebs2_tst(:,3) ;
y2=y2-1 ;

[ndata,vv] = size(x2) ;
% Set up network parameters.
net = mlp(nin, 5, nout, 'logistic');

% Set up vector of options for the optimiser.
options = zeros(1,18);
options(1) = 1;			% This provides display of error values.
options(9) = 1;			% Check the gradient calculations.
options(14) = 100 ;  	% Number of training cycles. 

% Train using scaled conjugate gradients.
[net, options] = netopt(net, options, x, t, 'scg');

% Plot the trained network predictions.

yp = mlpfwd(net, x2);
figure
plot( yp, 'ob') ;
hold on
plot(y2,'r+') ;
mmse = sum((yp-y2).^2) / ndata ;
printf('\n\n mean square error = %f\n',mmse) ;

return
