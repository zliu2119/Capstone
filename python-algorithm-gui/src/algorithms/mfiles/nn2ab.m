% Generate the matrix of inputs x and targets t.
%
%%
%
clc
close all
clear all
titrs = { 'height' , 'weight' , 'gender' } ;
load celebs2 ;
[mtr,ntr] = size(celebs2_tr) ;
[mtst,ntst] = size(celebs2_tst) ;
nin=2 ;
nout=1;
ndata=mtr ;

x = celebs2_tr(:,1:2) ;
t = celebs2_tr(:,3) ;
% normalization ....
t = (t==1) .* 0.05 + (t==2) .* 0.95 ;

% Set up network parameters.
net = mlp(2, 9, 1, 'logistic');
net.w1
net.w2
net.b1
net.b2
% Set up vector of options for the optimiser.
options = zeros(1,18);
options(1) = 1;			% This provides display of error values.
options(9) = 1;			% Check the gradient calculations.
options(14) = 600 ;  	% Number of training cycles. 
options 
% Train using scaled conjugate gradients.
[net, options] = netopt(net, options, x, t, 'scg');
options

net.w1
net.w2
net.b1
net.b2
% Plot the trained network predictions.
x2 = celebs2_tst(:,1:2) ;
y2 = mlpfwd(net, x2);
t2 = celebs2_tst(:,3) ;
t2 = (t2==1) .* 0.05 + (t2==2) .* 0.95 ;
figure(4) ;
plot(t2,'r*') ;
hold on ;
plot(y2,'bo') ;

t2
y2
printf('\n\n mean absolute error = %f\n\n', sum(abs(y2-t2))/mtst ) ;
 
%% --- Visualization -----------
figure ;
subplot(1,2,1) , ... 
scatter3(x(:,1) , x(:,2) , t , [], t ) , title('train set'), xlabel(titrs(1) ) , ylabel(titrs(2)) , zlabel(titrs(3)) ;
subplot(1,2,2) , colormap(jet) , ... 
scatter3(x2(:,1) , x2(:,2) , t2 , [] , t2), title('test set') , xlabel(titrs(1) ) , ylabel(titrs(2)) , zlabel(titrs(3)) ;

return
