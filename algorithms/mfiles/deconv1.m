a = [ 1,1,1,1 ; 0,2,2,0 ; -1,-2,0,1 ; -2, 3.3 , 1 , -2.5]

h1 = [ 1 , 1 ; 1 , 1]
hh = [0,0 ; 0 , 1]
r = conv2(h1,hh,'same')
b = conv2(a,h1,'same')

h1sp = [1 -1 ; -1 1]

h1p = zeros(6)
h1p(3:4,3:4) = h1

b = conv2(h1 , h1sp , 'same')

b = conv2(h1p , h1sp , 'valid')
