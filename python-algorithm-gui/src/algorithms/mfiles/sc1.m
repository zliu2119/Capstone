%
%
%
x=1:50 ;
y=zeros(50,50) ;
z=y ;
for i=1:50
  for j=1:50
    y(i,j) = -2.25 + 3.41*(i-25) + 6.7*(j-25) + 1.1*(i-25)^2 - 0.9*(j-25)^2;
    
  endfor
endfor


figure(1);

surf(y) , colormap(hsv) , title('Regression Model, Z = -2.25+3.4x+6.7y+1.1x^2-0.9y^2') ;
