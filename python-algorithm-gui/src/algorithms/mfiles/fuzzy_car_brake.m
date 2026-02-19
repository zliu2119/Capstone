function bp = fuzzy_car_brake(speed_in, distance_in)
%
% fuzzy logic to brake ...
% amir - oct 2019
% Revised April 2021
%

% clc;
% clear all;
% close all ;

% display('This example shows how Fuzzy Logic can be used') ;
% display('to design a car brakes controller system.') ;
%% make the fuzzy system
bb = newfis('brake.fis'); %create a new FIS file

% set type of fuzzy system : sugeno
bb = setfis(bb,'type','sugeno');

% defuzzification methods for sugeno : wtaver , wtsum
bb = setfis(bb,'defuzzmethod','wtaver');

%% definition of inputs and outputs
%% inputs;
bb = addvar(bb, 'input', 'distance', [1 100]);  %add an input variable distance' into the FIS
bb = addmf(bb, 'input', 1, 'near', 'gaussmf', [50 1]);
bb = addmf(bb, 'input', 1, 'medium', 'gaussmf', [20 50]);
bb = addmf(bb, 'input', 1, 'far', 'gaussmf', [20 100]);

bb = addvar(bb, 'input', 'speed', [1 120]); %add and input variable 'speed' into the FIS
bb = addmf(bb, 'input', 2, 'low', 'gaussmf', [20 1]);
bb = addmf(bb, 'input', 2, 'moderate', 'gaussmf', [40 50]);
bb = addmf(bb, 'input', 2, 'high', 'gaussmf', [60 120]);

bb = addvar(bb, 'input', 'light', [0.5 3.5]);%add and input variable 'light ' into the FIS
bb = addmf(bb, 'input', 3, 'green', 'gaussmf', [0.05 1]);
bb = addmf(bb, 'input', 3, 'yellow', 'gaussmf', [0.05 2]);
bb = addmf(bb, 'input', 3, 'red',  'gaussmf', [0.05 3]);

%% outputs;
bb = addvar(bb, 'output', 'bp', [1 4]);  %add and output variable 'bp' or brke pressure into the FIS
bb = addmf(bb, 'output', 1, 'no', 'constant',1);
bb = addmf(bb, 'output', 1, 'slight', 'constant',2);
bb = addmf(bb, 'output', 1, 'moderate', 'constant', 3);
bb = addmf(bb, 'output', 1, 'hard', 'constant',4);

%% definition of rules
% numeric rules ....
rules_num = [ 1 , 1 , 3 ,   4 ,1,1;
              1 , 2 , 3 ,   4 ,1,1;
              1 , 3 , 3 ,   4 ,1,1;
              1 , 1 , 2 ,   4 ,1,1;
              1 , 2 , 2 ,   4 ,1,1;
              1 , 3 , 2 ,   4 ,1,1;
              1 , 1 , 1 ,   1 ,1,1;
              1 , 2 , 1 ,   1 ,1,1;
              1 , 3 , 1 ,   3 ,1,1;
              2 , 1 , 3 ,   3 ,1,1;
              2 , 2 , 3 ,   4 ,1,1;
              2 , 3 , 3 ,   4 ,1,1;
              2 , 1 , 2 ,   3 ,1,1;
              2 , 2 , 2 ,   4 ,1,1;
              2 , 3 , 2 ,   4 ,1,1;
              2 , 1 , 1 ,   1 ,1,1;
              2 , 2 , 1 ,   1 ,1,1;
              2 , 3 , 1 ,   3 ,1,1;
              3 , 1 , 3 ,   3 ,1,1;
              3 , 2 , 3 ,   4 ,1,1;
              3 , 3 , 3 ,   4 ,1,1;
              3 , 1 , 2 ,   3 ,1,1;
              3 , 2 , 2 ,   3 ,1,1;
              3 , 3 , 2 ,   4 ,1,1;
              3 , 1 , 1 ,   1 ,1,1;
              3 , 2 , 1 ,   1 ,1,1;
              3 , 3 , 1 ,   3 ,1,1
              ]

bb = addrule(bb,rules_num);

% writefis(bb, 'brake.fis');
% bb=readfis('brake.fis');

%% Plot the input and output membership functions.
% plotmf (bb, 'input', 1);
% plotmf (bb, 'input', 2);
% plotmf (bb, 'input', 3);
% plotmf (bb, 'output', 1);

% showrule (bb);

% decided = ['no brake      ' ;
%            'push slightly ' ;
%            'push modrately' ;
%            'push hard!    '] ;

%% test
% fprintf('\n\nTEST ...\nDistance(m)\tSpeed(km/h)\tTr Light\tBrake Pr\n');
% x = [15,15,1 ; 50,5,3 ; 58,60,2] ;

bp = evalfis([distance_in, speed_in, 1], bb);

end
