%
%
%
%

function pup1 = next_gen(pup , ftn) 
  zzz = 0 ;
  pup1 = pup ;
  [M,N] = size(pup) ;
  for cnt=1:2:M
    cc=1 ;
    while (cc==1)
      i = randi(M) ;
      x = 1 / (1+ ftn(i) ) ;
      if ( x>=rand(1) )
        pr_ch_1 = pup(i,:) ;
        cc= 0 ;
        zzz = zzz+1 ;
      endif 
    endwhile
      
    cc=1 ;
    while (cc==1)
      i = randi(M) ;
      x = 1 / (1+ ftn(i) ) ;
      if ( x>=rand(1) )
        pr_ch_2 = pup(i,:) ;
        cc= 0 ;
        zzz = zzz+1 ;
      endif 
    endwhile
    cc = randi(N) ;
    tmp = pr_ch_1 ;
    pr_ch_1(1:cc) = pr_ch_2(1:cc) ;
    pr_ch_2(1:cc) = tmp(1:cc) ;
    pup1(cnt,:) = pr_ch_1 ;
    pup1(cnt+1,:) = pr_ch_2 ;
  endfor
  
endfunction
