
addpath ("./utils")

load "./RuleSets/PatternBased/TestPattern.mat" rule
% Neighborhoods need to be defined from center outwards in a clockwise spiral
load "./NeighborHoods/Moore.mat" neighbor_hood
load "./SubWindows/PLRosin.mat" sub_windows
load "./ruleLookUpTable/MooreWithCenter.mat" pattern_lookup_matrix
img = imread("./Images/blinker.png");

if (isbool(img))
	img = im2double(img, "indexed");
endif

result = edgeDetection(img, rule, neighbor_hood, sub_windows, pattern_lookup_matrix);

f = figure(1);
set(f, "color", [0.3 0.3 0.3])
imshow(result);
title('Output');

f = figure(2);
set(f, "color", [0.3 0.3 0.3])
imshow(img);
title('Input');
