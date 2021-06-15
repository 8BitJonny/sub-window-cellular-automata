
addpath ("./utils")

load "./RuleSets/GameOfLife.mat" rule
load "./NeighborHoods/Moore.mat" neighborHood

img = [
	0,0,0,0,0;
	0,0,1,0,0;
	0,0,1,0,0;
	0,0,1,0,0;
	0,0,0,0,0;
];

figure(1);
result = edgeDetection(img, rule, neighborHood);
imshow(result);
title('Output');