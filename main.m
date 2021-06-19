
addpath ("./utils")

profile on

load "./RuleSets/GameOfLife.mat" rule
load "./NeighborHoods/Moore.mat" neighborHood
img = imread("./Images/smiley.png");
% imfinfo("./Images/lena-binary.png")
img2 = im2double(img, "indexed");
img2 = img(:,:,1);

neighborHood = [-1 1; -1 0; -1 -1; 0 1; 0 -1; 1 1; 1 0; 1 -1];

% subwindows = { % as per Rosin P.L.
% 	{ [ 1, 1], [ 2, 2], [ 2, 1], [ 1, 2] },
% 	{ [-1,-1], [-2,-2], [-2,-1], [-1,-2] },
% 	{ [-1, 1], [-2, 2], [-2, 1], [-1, 2] },
% 	{ [ 1,-1], [ 2,-2], [ 2,-1], [ 1,-2] },
% 	{ [ 0, 1], [-1, 2], [ 0, 2], [ 1, 2] },
% 	{ [ 0,-1], [-1,-2], [ 0,-2], [ 1,-2] },
% 	{ [ 1, 0], [ 2, 1], [ 2, 0], [ 2,-1] },
% 	{ [-1, 0], [-2, 1], [-2, 0], [-2,-1] }
% };
subwindows        = [ 1  1;  2  2;  2  1;  1  2];
subwindows(:,:,2) = [-1 -1; -2 -2; -2 -1; -1 -2];
subwindows(:,:,3) = [-1  1; -2  2; -2  1; -1  2];
subwindows(:,:,4) = [ 1 -1;  2 -2;  2 -1;  1 -2];
subwindows(:,:,5) = [ 0  1; -1  2;  0  2;  1  2];
subwindows(:,:,6) = [ 0 -1; -1 -2;  0 -2;  1 -2];
subwindows(:,:,7) = [ 1  0;  2  1;  2  0;  2 -1];
subwindows(:,:,8) = [-1  0; -2  1; -2  0; -2 -1];

% img = [
% 	0,0,0,0,0;
% 	0,0,1,0,0;
% 	0,0,1,0,0;
% 	0,0,1,0,0;
% 	0,0,0,0,0;
% ];

figure(1);
result = edgeDetection(img2, rule, neighborHood, subwindows);
imshow(result);
% imshow(img2)
title('Output');

profile off

T = profile ("info")
profshow(T)