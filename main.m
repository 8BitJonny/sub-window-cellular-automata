
addpath ("./utils")

load "./RuleSets/PatternBased/TestPattern.mat" rule
% Neighborhoods need to be defined from center outwards in a clockwise spiral
load "./NeighborHoods/Moore.mat" neighborHood
load "./SubWindows/PLRosin.mat" subwindows
load "./ruleLookUpTable/MooreWithoutCenter.mat" patternLookupMatrix
img = imread("./Images/blinker.png");

if (isbool(img))
	img = im2double(img, "indexed");
endif

result = edgeDetection(img, rule, neighborHood, subwindows, patternLookupMatrix);

f = figure(1);
set(f, "color", [0.3 0.3 0.3])
imshow(result);
title('Output');

f = figure(2);
set(f, "color", [0.3 0.3 0.3])
imshow(img);
title('Input');
