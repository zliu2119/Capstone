
%
% fuzzy logic to brake ...
% v2, with variable modificatio
% amir - feb 2020
%


clc;
clear all;
close all ; 

display('This example shows how Fuzzy Logic can be used') ;
display('to design a car brakes controller system') ;
display('you can modify the parameters as well');
display('    ') ;
display('    ') ;
%% make the fuzzy system
bb = newfis('brake.fis'); %create a new FIS file

% set type of fuzzy system : sugeno
bb = setfis(bb,'type','sugeno');

% defuzzification methods for sugeno : wtaver , wtsum
bb = setfis(bb,'defuzzmethod','wtaver'); 

% distance para variables ...
d_dim = input('Distance between [min , max] meters: ') ;
dnv = input('standard deviation and max of NEAR distance [std,max]:') ;
dmv = input('standard deviation and max of MEDIUM distance [std,max]:') ;
dfv = input('standard deviation and max of FAR distance [std,max]:') ;

show_gauss(1, d_dim, dnv, dmv, dfv) ;

% speed para variables ...
s_dim = input('Speed between [min , max] km/h: ') ;
snv = input('standard deviation and max of LOW speed [std,max]:') ;
smv = input('standard deviation and max of MODERATE speed [std,max]:') ;
sfv = input('standard deviation and max of HIGH speed[std,max]:') ;

show_gauss(2, s_dim, snv, smv, sfv) ;

%% definition of inputs and outputs
%% inputs;
bb = addvar(bb, 'input', 'distance', d_dim);  %add an input variable distance' into the FIS
bb = addmf(bb, 'input', 1, 'near', 'gaussmf', dnv);
bb = addmf(bb, 'input', 1, 'medium', 'gaussmf', dmv);
bb = addmf(bb, 'input', 1, 'far', 'gaussmf', dfv);


bb = addvar(bb, 'input', 'speed', s_dim); %add and input variable 'speed' into the FIS
bb = addmf(bb, 'input', 2, 'low', 'gaussmf', snv );
bb = addmf(bb, 'input', 2, 'moderate', 'gaussmf', smv);
bb = addmf(bb, 'input', 2, 'high', 'gaussmf', sfv);


bb = addvar(bb, 'input', 'light', [0.5 3.5]);%add and input variable 'light ' into the FIS
bb = addmf(bb, 'input', 3, 'green', 'gaussmf', [0.02 1]);
bb = addmf(bb, 'input', 3, 'yellow', 'gaussmf', [0.02 2]);
bb = addmf(bb, 'input', 3, 'red',  'gaussmf', [0.02 3]);


%% outputs;
bb = addvar(bb, 'output', 'bp', [1 4]);  %add and output variable 'bp' or brke pressure into the FIS
bb = addmf(bb, 'output', 1, 'no', 'constant',1);
bb = addmf(bb, 'output', 1, 'slight', 'constant',2);
bb = addmf(bb, 'output', 1, 'moderate', 'constant', 3);
bb = addmf(bb, 'output', 1, 'hard', 'constant',4);

%% definition of rules
%rule6 = 'if (distance is near) and (speed is low) and (light is red)     then (bp is moderate)';
%rule2 = 'if (distance is near) and (speed is moderate) and (light is red)   then  (bp is hard)';
%rule3 = 'if (distance is near) and (speed is high) and (light is red)        then (bp is hard)';
%rule1 = 'if (distance is near) and (speed is low) and (light is green)         then (bp is no)';
%rule5 = 'if (distance is far) and (speed is low) and (light is red)  then       (bp is slight)';
%rule4 = 'if (distance is far) and (speed is moderate) and (light is red) then (bp is moderate)';
%rules = [rule1 ; rule2; rule3 ; rule4 ; rule5 ; rule6] ;

% numeric rules ....
rules_num = [ 1 , 1 , 3 ,   3 ,1,1;
              1 , 2 , 3 ,   4 ,1,1;
              1 , 3 , 3 ,   4 ,1,1;
              1 , 1 , 2 ,   3 ,1,1;
              1 , 2 , 2 ,   4 ,1,1;
              1 , 3 , 2 ,   4 ,1,1;
              1 , 1 , 1 ,   1 ,1,1;
              1 , 2 , 1 ,   1 ,1,1;
              1 , 3 , 1 ,   2 ,1,1;
              2 , 1 , 3 ,   2 ,1,1;
              2 , 2 , 3 ,   3 ,1,1;
              2 , 3 , 3 ,   4 ,1,1;
              2 , 1 , 2 ,   2 ,1,1;
              2 , 2 , 2 ,   3 ,1,1;
              2 , 3 , 2 ,   4 ,1,1;
              2 , 1 , 1 ,   1 ,1,1;
              2 , 2 , 1 ,   1 ,1,1;
              2 , 3 , 1 ,   2 ,1,1;
              3 , 1 , 3 ,   2 ,1,1;
              3 , 2 , 3 ,   3 ,1,1;
              3 , 3 , 3 ,   3 ,1,1;
              3 , 1 , 2 ,   2 ,1,1;
              3 , 2 , 2 ,   2 ,1,1;
              3 , 3 , 2 ,   3 ,1,1;
              3 , 1 , 1 ,   1 ,1,1;
              3 , 2 , 1 ,   1 ,1,1;
              3 , 3 , 1 ,   2 ,1,1
              ]
              
bb = addrule(bb,rules_num);

% bb = parsrule(bb,rules);
%showrule(bb) 
writefis(bb, 'brake.fis');

bb=readfis('brake.fis');

## Plot the input and output membership functions.
plotmf (bb, 'input', 1);
plotmf (bb, 'input', 2);
plotmf (bb, 'input', 3);
plotmf (bb, 'output', 1);


showrule (bb);


%% test
fprintf('\n\nTEST ...\ninputs:\n');
x = [15,15,1 ; 50,5,3 ; 58,14,2] 
fprintf('\noutputs:\n\n\n');
evalfis(x,bb)

decided = ['no brake      ' ; 
           'push slightly ' ; 
           'push modrately' ; 
           'push hard!    '] ;
x = [] ;
x = input('enter the inputs [distance (m), speed (km/h), light (g=1, y=2, r=3]: ') ;
while (size(x) ~= 0)
    zans = evalfis(x,bb) ;
    fprintf('\nAnswer = %f ==> %s\n',zans , decided(round(zans),:) ) ;
    x = input('enter the inputs [distance (m), speed (km/h), light (g=1, y=2, r=3]: ') ;
end
return

