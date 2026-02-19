%
%
%
%

function pup1 = tsm_next_gen(pup , ftn) 

  pup1 = pup ;
  [M,N] = size(pup) ;
  if ( max(ftn) == min(ftn) )
    return 
  endif
  zztop = ( 1./ (1+ftn)) ;
  zztop = (zztop - min(zztop)) ./ (max(zztop) - min(zztop) ) ; 
  
  for cnt=1:2:M
    cc=1 ;
    while (cc==1)
      i = randi(M) ;
      if ( zztop(i)>=rand() )
        pr_ch_1 = pup(i,:) ;
        cc= 0 ;
      endif 
    endwhile

    cc=1 ;
    while (cc==1)
      i = randi(M) ;
      if ( zztop(i)>=rand() )
        pr_ch_2 = pup(i,:) ;
        cc= 0 ;
      endif 
    endwhile

    [pr_ch_1 , pr_ch_2] = crossover_tsm1(pr_ch_1 , pr_ch_2) ; 
    pup1(cnt,:) = pr_ch_1 ;
    pup1(cnt+1,:) = pr_ch_2 ;
    
    %pause(20) 
  endfor
 
 
endfunction
