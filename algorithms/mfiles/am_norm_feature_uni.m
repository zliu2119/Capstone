%
% feature matrix normalization, using uniform alg
% input:  feature matrix , no_out switch, if 1 => output var wont be normalized
% output: normalized feature matrix , normalization coefficients = scale
% amir - 2021
%

function [dd,nrcoef] = am_norm_feature_uni(dd, no_out) 
  
  nrcoef = max(abs(dd)) ;
  [MM,NN] = size(dd) ;
  for i=1:NN-no_out
    dd(:,i) = dd(:,i) ./ nrcoef(i) ;
  endfor
  
return
