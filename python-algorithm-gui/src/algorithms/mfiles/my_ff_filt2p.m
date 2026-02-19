%  my_ff_filt2(inmat , filter : function for doing Frequency domain filtering 
%		input : inmat = matrix of frequency domain input , 
%					filter = filter matrix  , must be in the same size with inmat
%		out put is an complex matrix in spatial domain after filtering
%		amir - june 2001
%       revised nov 2007 , for lower level comp

function cc = my_ff_filt2p( inmat ,  filtmat ) 

ffa1 = abs(inmat) ;
ffang1 = angle(inmat) ;
%figure
%mesh(unwrap(ffang1)) , colorbar ; 
ffa1= fftshift(ffa1) ;
ffa1 = ffa1 .* filtmat  ; 
ffa1 = ifftshift(ffa1) ;
%ffang1(:,:)= ffang1(:,:) + randn(size(ffang1))  ;
a1 = ffa1 .* cos( ffang1 ) ;
b1 = ffa1 .* sin( ffang1 ) ;
cc = a1 + i .* b1 ;
cc = ifft2(cc) ;

return

