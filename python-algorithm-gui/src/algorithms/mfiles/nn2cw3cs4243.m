% Generate the matrix of inputs x and targets t.
%
%%
%
clc
close all
clear all
nin= 2 ;
nout=1;
ndata= 4 ;

%x = [ 0,0,0 ; 0,0,1 ; 0,1,0 ; 0,1,1 ; 1,0,0 ; 1,0,1 ; 1,1,0 ; 1,1,1 ];
%t = [ 1 ; 0 ; 0 ; 1 ; 0 ; 1 ; 1 ; 0 ] ;
x = [ 0,0 ; 0,1 ; 1,0 ; 1,1 ];
t = [ 1 ; 0 ; 0 ; 1 ] ;


% Set up network parameters.
net = mlp(2, 3, 1, 'logistic');
net.w1
net.w2
net.b1
net.b2
% Set up vector of options for the optimiser.
options = zeros(1,18);
options(1) = 1;			% This provides display of error values.
options(9) = 1;			% Check the gradient calculations.
options(14) = 90 ;  	% Number of training cycles.

% Train using scaled conjugate gradients.
[net, options] = netopt(net, options, x, t, 'scg');

fprintf('\nW1=\n') ;
net.w1
fprintf('\nW2=\n') ;
net.w2
fprintf('\nb1=\n') ;
net.b1
fprintf('\nb2=\n') ;
net.b2
% Plot the trained network predictions.
t
y = mlpfwd(net, x);
figure
plot( y, 'ob')
y

for i=1:4
  x1=x(i,:)
  y1 = x1 * net.w1
  y1= y1 + net.b1
  y2 = 1 ./ (1+exp(-y1))
  y3 = y2 * net.w2
  y3 = y3 + net.b2
  y3 = 1 / (1+exp(-y3))
  y3p = mlpfwd(net,x1)
end

return
