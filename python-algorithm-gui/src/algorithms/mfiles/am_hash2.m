% hashing and solving simple blockchain puzzles
%
% amir - Feb 2020
%

clc
clear all
close all
warning off ;
display('This example is the Hash key generation with 000 at the end') ;

dd = input('string :','s') ;
while ( size(dd) ~= 0 )
  c = 0 ;
  cnt=1 ;
  endof= size( dd );
  endof = max(endof) ;
  sw =1 ;
  for i=1:endof
      c = c + double(dd(i))*10^(i-1) ;
  endfor
  c = mod(c,2^24) ;
  if (mod(c,1000) == 0)
    sw=0 ;
  endif
  while(sw==1)
    nonc = randi([1,5],1) ;
    key_nonc = [] ;
    for j=1:nonc
      key_nonc = [key_nonc , char( randi([32,127],1) ) ] ;
    endfor
    ddtmp = dd ;
    ddtmp = [ddtmp , key_nonc ] ;
    fprintf('try no %d ,   %s\n', cnt, ddtmp) ;
    endof= size( ddtmp );
    endof = max(endof) ; 
    for i=1:endof
      c = c + double(ddtmp(i))*10^(i-1) ;
    endfor
    c = mod(c,2^24) ;
    if (mod(c,1000) == 0)
      dd = ddtmp ;
      sw=0 ;
    endif
    cnt = cnt + 1 ;
  endwhile  
  fprintf('\n final string:  %s\n     hash=\t %d (d)  =   %x (h)\n\n',dd,c,c ) ;
  dd = input('string :','s') ;
endwhile

return
