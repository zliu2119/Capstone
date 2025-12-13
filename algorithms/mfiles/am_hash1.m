
clc
clear all
close all

display('This example is the Hash function') ;

dd = input('string >','s') ;
[M,N] = size(dd) ;
while ( size(dd) ~= 0 )
  c = 0 ;
  for i=1:N
    c = c + double(dd(i))*10^(i-1) ;
  endfor
  c = mod(c,1024) ;
  fprintf('  hash=\t %d (d) =  %x (h)\n\n',c,c ) ;
  dd = input('string >','s') ;
  [M,N] = size(dd) ;
endwhile

return
