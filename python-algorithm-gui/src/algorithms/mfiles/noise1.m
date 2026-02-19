%
%
%

function a = noise1(a,level)
  
a = a + randn(size(a)).* level ;
a = uint8(a) ;

return