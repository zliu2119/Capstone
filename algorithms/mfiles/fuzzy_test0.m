
close all
clear all
clc


a=imread('d7.jpg') ;
Igray = rgb2gray(a);
figure
image(Igray,'CDataMapping','scaled')
colormap('gray')
title('Input Image in Grayscale')

I = double(Igray) ;
Gx = [-1 1];
Gy = Gx';
Ix = conv2(I,Gx,'same');
Iy = conv2(I,Gy,'same');
figure(2) ;
mesh(Ix) , view(2) ;
%% make the fuzzy system
edgeFIS = newfis('im.fis'); %create a new FIS file

% set type of fuzzy system : mamdani
edgeFIS = setfis(edgeFIS,'type','mamdani');
% defuzzification methods for sugeno : wtaver , wtsum
edgeFIS = setfis(edgeFIS,'defuzzmethod','wtaver'); 
puts('\n\n here ....\n') ;
%%%%edgeFIS = mamfis('Name','edgeDetection');
%%edgeFIS = addinput(edgeFIS,[-1 1],'Name','Ix');
%%edgeFIS = addinput(edgeFIS,[-1 1],'Name','Iy');
edgeFIS = addvar(edgeFIS, 'input', 'Ix', [-1 1]);  %add an input variable distance' into the FIS
edgeFIS = addvar(edgeFIS, 'input', 'Iy', [-1 1]);  %add an input variable distance' into the FIS
%
sx = 0.1;
sy = 0.1;
edgeFIS = addmf(edgeFIS,'Ix','gaussmf',[sx 0],'Name','zero');
edgeFIS = addmf(edgeFIS,'Iy','gaussmf',[sy 0],'Name','zero');
edgeFIS = addvar(edgeFIS, 'output' , 'Iout', [0 1]);
%
wa = 0.1;
wb = 1;
wc = 1;
ba = 0;
bb = 0;
bc = 0.7;
edgeFIS = addmf(edgeFIS,'Iout','trimf',[wa wb wc],'Name','white');
edgeFIS = addmf(edgeFIS,'Iout','trimf',[ba bb bc],'Name','black');
figure
subplot(2,2,1)
plotmf(edgeFIS,'input',1)
title('Ix')
subplot(2,2,2)
plotmf(edgeFIS,'input',2)
title('Iy')
subplot(2,2,[3 4])
plotmf(edgeFIS,'output',1)
title('Iout') 

r1 = "If Ix is zero and Iy is zero then Iout is white";
r2 = "If Ix is not zero or Iy is not zero then Iout is black";
edgeFIS = addrule(edgeFIS,[r1 r2]);
edgeFIS.rule

Ieval = zeros(size(I));
%%writefis(edgeFIS, 'im.fis');

%%edgeFIS=readfis('im.fis');
%% test
for ii = 1:size(I,1)
Ieval(ii,:) = evalfis([(Ix(ii,:));(Iy(ii,:))]' ,edgeFIS);
end

figure
image(I,'CDataMapping','scaled')
colormap('gray')
title('Original Grayscale Image')

figure
image(Ieval,'CDataMapping','scaled')
colormap('gray')
title('Edge Detection Using Fuzzy Logic')

return
