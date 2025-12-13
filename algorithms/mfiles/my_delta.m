% a delta function for 2nd order equations
%
% amir - 2010 

function [d,c] = my_delta(aa,bb,cc) 
  c=0;
  d = bb^2 - 4*aa*cc ;
  c = (d>0)* 1 + (d<0)* -1 ;
endfunction
