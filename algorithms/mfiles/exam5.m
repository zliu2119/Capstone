
clc
for i=1:10
  i
  j = i^2
endfor
%%---------------------------------
for i=10:1
  i
endfor

%%--------------------------------
for i=-5:0.1:5
  i
endfor
i
%-----------------------------
while (i>=-8)
  i=i-1 ;
  j=i^2
endwhile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fib = ones (1, 20);
i = 2;
do
  i++;  % i++ ==== i=i+1 , i-- === i=i-1
  fib (i) = fib (i-1) + fib (i-2);
until (i == 20)
fib
%*****************************
for k=fib
  k
endfor
