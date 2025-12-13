%
% ANN Calculator
% Amir - 2019
%
close all
clear all
clc

nin=2 ;
nout=1;
ndata=300 ;
display(' Select the operation ') ;

nnopt = {"1- summation ", "2- subtraction", "3- multiplication" , "4- division"};
[op , ok1] = listdlg ("ListString", nnopt, "SelectionMode", "Single", ...
"ListSize",[400,300], "PromptString" , " Select Your Operation " , "Name" , "ANN Calculator");
if (ok1 ~= 1)
   return;
endif
prompt = {"Number of samples: (90/10, Tr/Tst)","Number of hidden layer nodes:", "Training epochs:"};
rowscols = [1,10; 1,10 ; 1,10];
dims = inputdlg (prompt, "Enter Data", rowscols);
ndata = str2num( cell2mat(dims(1))) ;
hnode = str2num( cell2mat(dims(2))) ;
epch = str2num( cell2mat(dims(3))) ;

op2 = ['+' ; '-' , 'x' , '/'] ;
ndata2 = round(ndata/10) ;
x = (rand(ndata,2)-0.5) .* 10 ;
x2 = (rand(ndata2,2)- 0.5) .* 10 ;
switch (op)
  case {1}
    t = x(:,1) + x(:,2) ;
    t2 = x2(:,1) + x2(:,2) ;
    opchr = '+' ;
  case {2}
    t = x(:,1) - x(:,2) ;
    t2 = x2(:,1) - x2(:,2) ;
    opchr = '-' ;
  case {3}
    t = x(:,1) .* x(:,2) ;
    t2 = x2(:,1) .* x2(:,2) ;
    opchr = '*' ;
  case {4}
    t = x(:,1) ./ x(:,2) ;
    t2 = x2(:,1) ./ x2(:,2) ;
    opchr = '/' ;
  otherwise
    error ("invalid value");
    return
endswitch

figure ;
scatter3( x(:,1) , x(:,2) , t , "r", "+") ;
title(['operation ' , op2(op) , ' scatter plot']) ;
% Set up network parameters.
net = mlp(2, hnode, 1, 'linear');

% Set up vector of options for the optimiser.
options = zeros(1,18);
options(1) = 1;			% This provides display of error values.
options(9) = 1;			% Check the gradient calculations.
options(14) = epch;  	% Number of training cycles. 

% Train using scaled conjugate gradients.
[net, options] = netopt(net, options, x, t, 'scg');

% Plot the trained network predictions.

y = mlpfwd(net, x2);
figure ;
plot( y, 'ob') , title([op2(op),' Target (red) vs. Predicted (blue)']) ;
hold on ;
plot( t2, '+r') ;

err = sum(abs(y-t2)) /ndata2 ;
printf('\n\n RESULTS ...\n\n') ;
for i=1:ndata2
  printf('\n %7.4f %s %7.4f = %8.4f \t\t, abs error=%f' , x2(i,1) , opchr , x2(i,2) , y(i) , abs(t2(i)-y(i)) ) ;
endfor

printf('\n\n\n Mean Abs Error= %f \t Mean Square Error= %f \t Root MSE= %f\n\n', err, my_mse(y,t2), my_mse(y,t2)^0.5 ) ;

return
