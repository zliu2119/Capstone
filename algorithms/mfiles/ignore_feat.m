%
% to delete features from the feature set
% input:  feature matrix , list of columns to be deleted
% output: filtered feature matrix 
% last column shouldnt be included
% amir - 2021
%

function eee = ignore_feat(ddd,igfeat)
  
  minus_inf = -9e35 ;
  eee=[] ;
  [MM,NN] = size(ddd) ;
  for i=igfeat
    if (i<1 || i>=NN)
      display('Selected features are not in range ...') ;
      display('  No filtering would be done!') ;
      eee=ddd ;
      return
    endif
    ddd(1,i) = minus_inf ;
  endfor
  for i=1:NN
    if ddd(1,i) ~= minus_inf
      eee = [eee , ddd(:,i)] ;
    endif
  endfor
  
return 
