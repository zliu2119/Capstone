%% normal distribution

clear all
x=[-10:0.01:10] ;
y=exp(-x.^2./2) ./ (2*pi)^0.5 ;
plot(x,y)
sum(y)
sum(y) *0.01

return