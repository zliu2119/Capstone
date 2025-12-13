%
%
%

[nul , rb1] = xlsread('logic_ex1.xlsx') ;
[MM,NN] = size( rb1 ) ;
NoR = 4 ;
rb2 = zeros( NoR,NN-1 ) ;

for i=1:MM
  res = cell2mat( rb1(i,NN) ) ;
  res= tolower(res) ;
  res2 = uint8(res) - 96 ;
  for j=1:NN-1
    xyz = cell2mat( rb1(i,j) ) ;
    if (prod( size(xyz) ) ~=0)
      xyz = tolower(xyz) ;
      xyz2 = uint8(xyz) - 96 ;
      rb2(res2,xyz2) = rb2(res2,xyz2) + 1 ;
    endif
  endfor
endfor

rbtmp = zeros(size(rb2)) ;
fct = input("please enter the fact: ", "s") ;
facts = zeros(26,1) ;
fctind = uint8(fct) - 96 ;
facts(fctind) = 1 ;

for i=1:NoR
  if facts(i)==1
    for j=1:NoR
      if rb2(j,i)==1
        facts(j)=1 ;
      endif
    endfor
  endif
endfor

prvfct="" ;
for i=1:26
  if facts(i)==1
    prvfct = [char(i+96), " , " , prvfct] ;
  endif
endfor
printf('\n Facts-Proven: %s\n' , prvfct) ;

return

