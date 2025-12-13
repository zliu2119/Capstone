
ff = imread("d:\\imoortant\\ann\\media\\image.png") ;
ff = imresize(ff, [512,512]) ;
mov=[] ;

for i=1:200
  aa = im2frame(ff) ;
  mov = [mov ; aa ] ;
  ff = 255-ff ;
endfor

movie(mov) ;

return

