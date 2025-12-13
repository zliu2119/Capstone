%
%
%

axis ([-1, 1, -0.75, 1.25], "square");
% figure(1, "visible", "off");                          % no plotting window
figure(1) ;
hold on;

% defining the vertices of an equilateral triangle (symmetric to y-axis)
V = [ 0, 1;                                           % top vertex
     cos( (pi/2)+(2*pi/3) ), sin( (pi/2)+(2*pi/3) );  % left vertex
     cos( (pi/2)-(2*pi/3) ), sin( (pi/2)-(2*pi/3) )   % right vertex
     ];

r = floor(3*rand(1)+0.9999999999);                    % integer random number in [1:3]
x = [ V(r,1), V(r,2) ];                               % initializing x on random vertex

for i = 1:8000 % !!! 100000 => time=130m57.343s
  r = floor(3*rand(1)+0.9999999999);                  % integer random number in [1:3]
  x = ( x+V(r,[1:2]) )./2;                            % halfway, current to random vertex
  plot(x(1),x(2), ".");
  %pause(2)
endfor

print -dpng "C:\\Users\\sleam\\Desktop\\sierpinski_m.png";