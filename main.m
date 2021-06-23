
addpath ("./utils")

load "./RuleSets/GameOfLife.mat" rule
load "./NeighborHoods/Moore.mat" neighborHood
load "./SubWindows/PLRosin.mat" subwindows
img = imread("./Images/lena-binary.png");
img = im2double(img, "indexed");
result = edgeDetection(img, rule, neighborHood, subwindows);

figure(1);
imshow(result);
title('Output');

figure(2);
imshow(img);
title('Input');
