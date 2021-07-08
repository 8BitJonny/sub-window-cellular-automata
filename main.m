pkg load image
addpath ("./utils")

load "./RuleSets/PatternBased/TestPattern.mat" rule
% Neighborhoods need to be defined from center outwards in a clockwise spiral
load "./NeighborHoods/Moore.mat" neighbor_hood
load "./SubWindows/PLRosin.mat" sub_windows
load "./ruleLookUpTable/MooreWithCenter.mat" pattern_lookup_matrix
img = imread("./Images/lena-binary.png");

if (isbool(img))
	img = im2double(img, "indexed");
endif

result = edgeDetection(img, rule, neighbor_hood, sub_windows, pattern_lookup_matrix);

cannyResult = edge(mat2gray(img), "Canny");
sobelResult = edge(mat2gray(img), "Sobel");
prewittResult = edge(mat2gray(img), "Sobel");

plots_to_print = struct()
plots_to_print.("Input") = img;
plots_to_print.("Ground Truth") = cannyResult;
plots_to_print.("Output") = result;
plots_to_print.("Sobel") = sobelResult;
plots_to_print.("Prewitt") = prewittResult;

plotResults(plots_to_print);
