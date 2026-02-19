%
% feature matrix normalization, using uniform alg
% input:  feature matrix , no_out switch, if 1 => output var wont be normalized
% output: normalized feature matrix , normalization coefficients = mean and std
% amir - 2021
%

function [dd,mu,sig] = am_norm_feature_gu(dd,no_out) 
  
  mu = mean(dd) ;
  sig = std(dd) ;
  [MM,NN] = size(dd) ;
  for i=1:NN-no_out
    dd(:,i) = (dd(:,i)-mu(i)) ./ sig(i) ;
  endfor
  
return
