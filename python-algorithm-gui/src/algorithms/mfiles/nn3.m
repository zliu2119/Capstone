%
%%
%
clc
close all
clear all
XX = csvread('wine_r1.csv') ;

[mtr,ntr] = size(XX) ;

nin=ntr-1 ;
nout=1;
ndata=mtr ;

x = XX(:,1:ntr-1) ;
t = XX(:,ntr) ;

% Set up network parameters.
net = mlp(nin, 200, 1, 'linear');
 
% Set up vector of options for the optimiser.
options = zeros(1,18);
options(1) = 1;			% This provides display of error values.
options(9) = 1;			% Check the gradient calculations.
options(14) = 9900 ;  	% Number of training cycles. 
options 
% Train using scaled conjugate gradients.
[net, options] = netopt(net, options, x, t, 'scg');
options
 
% Plot the trained network predictions.
x2 = x ;
y2 = mlpfwd(net, x2);
t2 = t ;
 
figure(1) ;
plot(t2,'r^') ;
hold on ;
plot(y2,'bo') ;

figure(2)
plot( abs(t2-y2) ,'m*') , title('absolute error') ;

figure(3) ;
plot(t2(1:100),'r^') ;
hold on ;
plot(y2(1:100),'bo') ;
hold on
plot( abs(t2(1:100)-y2(1:100)) ,'m*') , title('100  first') ;

figure(4) ;
plot(t2(1500:1580),'r^') ;
hold on ;
plot(y2(1500:1580),'bo') ;
hold on
plot( abs(t2(1500:1580)-y2(1500:1580)) ,'m*') , title('80 last') ;


printf('\n\n mean absolute error = %f\n\n', sum(abs(y2-t2))/mtr ) ;

return
