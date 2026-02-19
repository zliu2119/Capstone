% horder : a function to change the row number of natural hadamard 
% matrix to ordered one, input : b= natural row number -1 = sequence and nn=length of 
% number in binary (for 8*8 matrix nn=3)
% output : ordered row number -1 (again sequence)
% amir - may 01
%

function k = horder(b,nn) 

jj = int2bin(b,nn) ;
for j=1:nn
      kk(j) = jj(nn-j+1) ;
end
   
kkk=zeros(1,nn) ;
kkk(1) = kk(1) ;
for j=2:nn
   kkk(j) = xor( kk(j-1),kk(j) ) ;
end
k=0 ;
for j=1:nn
   k = k + ( kkk(j) .* 2^(j-1) ) ;
end
return