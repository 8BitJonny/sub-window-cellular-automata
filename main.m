
addpath ("./utils")

% load "./RuleSets/GameOfLife.mat" rule
rule = 84; % 1010100
% Neighborhoods need to be defined from center outwards in a clockwise spiral
load "./NeighborHoods/Moore.mat" neighborHood
load "./SubWindows/PLRosin.mat" subwindows
load "./ruleLookUpTable/MooreWithoutCenter.mat" patternLookupMatrix
img = imread("./Images/blinker.png");

if (isbool(img))
	img = im2double(img, "indexed");
endif

result = edgeDetection(img, rule, neighborHood, subwindows, patternLookupMatrix);
figure(1);
imshow(result);
title('Output');

figure(2);
imshow(img);
title('Input');
