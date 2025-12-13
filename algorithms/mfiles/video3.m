pause(30)
ff = imread("d:\\imoortant\\ann\\media\\imag2.png") ;
gg = imread("d:\\imoortant\\ann\\media\\mask22.png") ;
gg(:,:,3) = 0 ;
mov=[] ;
coef= 2 ;
xstride= 76 * coef;
ystride= 70 * coef ;

[MM,NN,KK] = size(ff) ;
[MMM,NNN,KK] = size(gg) ;

for j=6:ystride:MM-MMM-1
   for i=5:xstride:NN-NNN-1
     hh= ff ;
     hh(j:j+MMM-1,i:i+NNN-1,:) = gg(:,:,:) ;
     aa = im2frame(hh) ;
     mov = [mov ; aa ] ;
   endfor
endfor
pause(5) ;
aa = im2frame(ff) ;
mov = [mov ; aa ] ;
movie(mov, 1, 1) ;

return

