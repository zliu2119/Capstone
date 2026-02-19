% h = ordhad(n) 
% generate a n*n ordered hadamard matrix
% amir - may 01
%

function hh = ordhad(n) 

h = hadamard(n) ;
nn = log2(n)  ;
for i=0:n-1
   k = horder(i,nn) ;
   hh(i+1,:) = h(k+1,:) ;
end

return