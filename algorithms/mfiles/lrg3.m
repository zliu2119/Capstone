% Linear Regression, V3.0
% y=f(x1,x2,...,x11) , for wine quality function
% Amir - 2020
%
clc
clear all
close all

# your wine quality assessment data
a = csvread('wine_r1.csv') ;
y = a(:,12)' ;
a= a(:,1:11)' ;

[M,N] = size(a) ;

# create the design matrix
# intercept (1s), wine features
X = [ ones(1,N) ; a ]' ;
# linear parameter estimates
b = inv(X'*X)*X'*y' ;  %% pinv(X) = (X'*X)*X' ==> coeeficients

# residuals
R = y' - (X * b) ;
# residual variance
v = (R'*R)/(4 - 3) ;
# variance covariance matrix of parameters
Sigma = v * inv(X'*X) ;
# standard errors of parameters (b vector)
se = sqrt(diag(Sigma)) 
%% test ....
newdata = X ;
# predicted values  
pred = newdata * b ;
rr=randi([3 8] , size(pred) ) ;
fprintf( '\n\nMSE = %f, \t Random MSE=%f\n', sum((y'-pred) .^ 2) / M , sum((rr-pred) .^ 2) / M ) ; 
figure ;
plot(y,'b+') , hold on , plot(pred','r*') , title('blue=real, red=estimated scores') ;
b
%----------------------------- 
[b, bint, r, rint, stats] = regress (y', a') ;
b
newdata = a ;
pred = newdata' * b ;
rr=randi([3 8] , size(pred) ) ;
fprintf( '\n\nMSE = %f, \t Random MSE=%f\n', sum((y'-pred) .^ 2) / M , sum((rr-pred) .^ 2) / M ) ; 
figure ;
plot(y,'b+') , hold on , plot(pred','r*') , title('blue=real, red=estimated scores') ;

return