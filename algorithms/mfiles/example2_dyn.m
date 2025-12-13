% example 2
% modification of brightness, contrast, and the dynamic range
%
% amir monadjemi - 2015
%

% dont forget the housekeeping 
clear all
close all
clc

% this time, theimage file name is constant
fnam = '81HRDxoQB+L._SL1500_.jpg' ;
% then we read it into thematrix a
a = imread(fnam) ;
figure(1);
% show it
imshow(a) , title(['original image  ' , fnam]) ;
% convert it to double type
a = double(a) ;
% convert it to graylevel simply by averaging the R,G, and B channels
b = ( a(:,:,1) + a(:,:,2) + a(:,:,3) ) ./ 3 ;
% in figure 2 we show the original gray level image and its histogram
% then the user is asked to enter the new dynamic range using a [min max]
% format. 
figure(2);
subplot(2,3,1) , imshow(uint8(b)) , title(['a) gray level image  ' , fnam]) ;
subplot(2,3,4) , imhist(uint8(b)) , title(['d) original histogram  ' , fnam]) ;
new1 = input('enter new dynamic range:') ;
% to help the user we show the current min / max 
mx = max(max(b)) 
mn = min(min(b)) 
% changing the dynamic range, then showing the results 
b= ( ( b - mn ) ./ (mx-mn) .* (new1(2)-new1(1)) ) + new1(1) ;
figure(2);
subplot(2,3,2) , imshow(uint8(b)) , title(['b) adjusted image  ' , fnam]) ;
subplot(2,3,5) , imhist(uint8(b)) , title(['e) adjusted histogram  ' , fnam]) ;

%
% once again, we start from the original image, since b is modified
% we repeat the gray level conversion. this time we are going to 
% modify the dynamic range of just a portion of the image.
% user select the region
%
b = ( a(:,:,1) + a(:,:,2) + a(:,:,3) ) ./ 3 ;
% 
% the size isshown to help the user in region of interest selection
% the user enters two vectors: [x1 y1 x2 y2] , and [min max]
size(b)
[xy] = input('enter the region of interest: ') ;
new1 = input('enter new dynamic range:') ;
x1 = xy(1) ;
y1 = xy(2) ;
x2 = xy(3) ;
y2 = xy(4) ;
mx = max(max(b(y1:y2,x1:x2))) 
mn = min(min(b(y1:y2,x1:x2))) 
%
% the new regional dynamic range is set
b(y1:y2,x1:x2)= ( ( b(y1:y2,x1:x2) - mn ) ./ (mx-mn) .* (new1(2)-new1(1)) ) + new1(1) ;
%
% and the results are illustrated
figure(2);
subplot(2,3,3) , imshow(uint8(b)) , title(['c) region adj image  ' , fnam]) ;
subplot(2,3,6) , imhist(uint8(b(y1:y2,x1:x2))) , title(['f) region adj histogram  ' , fnam]) ;
% we have employed a 2x3=6 windowed subplot. you also may use 
% subplot(2,3,i) in a loop
return
% bye .....
