d = zeros(200,200) ;
for i=1:200
  for j=1:200
    z= (2500-(i-100)^2-(j-100)^2) ;
    if z>=0
      d(i,j)= z ^ 0.5 ;
    endif
  end
end

colormap(hsv), surf(d)

d = zeros(200,200) ;
for i=1:200
  for j=1:200
    
    if i>=100 && j>=100
      d(i,j)= i+j-200 ;
    endif
  end
end

figure
colormap(summer) , surf(d)

d = zeros(200,200) ;
for i=1:200
  for j=1:200
    
    if i>=50 && j>=50 && i<150 && j<150
      d(i,j)= 100 ;
    endif
  end
end

figure
colormap(autumn) , surf(d)
