%
% Logic and decision making
% Amir - NUS / SoC - 2021
%
clear
clc
close all

xlsname = input('What is your Knowledgebase? ' , 's') ;
[nul , rb1] = xlsread(xlsname) ;
[MM,NN] = size( rb1 ) ;
rb2 = char( zeros(size(rb1))+ 32 ) ;
spckey = char( zeros(1,NN-1)+ 32 ) ;
for i=1:MM
  for j=1:NN
    btmp = cell2mat(rb1(i,j)) ;
    if prod(size(btmp)) ~= 0
      rb2(i,j) = tolower(btmp) ;
    endif
  endfor
endfor

farz = rb2(:,1:NN-1) ;
hokm = rb2(:,NN) ;
facts = "" ;
fct = input('Enter The Fact > ' , 's') ;

while size(fct) ~= 0
  fct = tolower( fct ) ;
  facts = [facts , fct] ;
  for i=1:MM
    for j=1:NN-1
      if farz(i,j) == fct 
        farz(i,j) = " " ;
      endif
    endfor
  endfor
  for k=1:MM
    if farz(k,:) == spckey 
      fct = hokm(k) ;
      facts = [facts , fct] ;
      for i=1:MM
        for j=1:NN-1
          if farz(i,j) == fct 
            farz(i,j) = " " ;
          endif
        endfor
      endfor
    endif
  endfor
  facts = del_repeated( facts ) ;
  printf('\n facts-proven : ') ;
  for pri=1:prod(size(facts)) 
    printf("%c , ", facts(pri) ) ;
  endfor
  printf('\n') ;
  fct = input('Enter The Fact > ' , 's') ;
endwhile

return 
