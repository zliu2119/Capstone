%
% amir's fibonatchi
%
function  fib = am_fibonatchi(n)
  
fib = ones (1, n);
i = 2;
do
  i++;
  fib (i) = fib (i-1) + fib (i-2);
until (i == n)

endfunction