%
%
%

function b = color_swap(b) 
del = randi([1,3]) ;
if del==1
  tmp = b(:,:,1) ;
  b(:,:,1) = b(:,:,2) ;
  b(:,:,2) = b(:,:,3) ;
  b(:,:,3) = tmp ;
elseif del==2
  tmp = b(:,:,3) ;
  b(:,:,3) = b(:,:,2) ;
  b(:,:,2) = b(:,:,1) ;
  b(:,:,1) = tmp ;
else
  tmp = b(:,:,2) ;
  b(:,:,3) = b(:,:,2) ;
  b(:,:,2) = tmp ;
endif

endfunction
