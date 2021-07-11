pkg load image
addpath ("./utils")

% Neighborhoods need to be defined from center outwards in a clockwise spiral
load "./NeighborHoods/Moore.mat" neighbor_hood
load "./ruleLookUpTable/MooreWithCenter.mat" pattern_lookup_matrix

% ground_truth = load("./images/cracks/001/groundTruth.mat").("groundTruth").("Boundaries");

test_rule = load("./RuleSets/PatternBased/TestPattern.mat").("rule");
otca_832_rule = load("./RuleSets/CountBased/OTCA832.mat").("rule");

rosin_sub_window = load("./SubWindows/PLRosin.mat").("sub_windows");
no_effect_sub_window = load("./SubWindows/NoEffect.mat").("sub_windows");

lena_img = imread("./Images/lena-binary.png");
blinker_img = imread("./Images/blinker.png");
% Image to be used
img = lena_img;

if (isbool(img))
	img = im2double(img, "indexed");
endif

plain_otca_result = edgeDetection(img, otca_832_rule, neighbor_hood, no_effect_sub_window); 						% Count Mode
sub_window_otca_result = edgeDetection(img, otca_832_rule, neighbor_hood, rosin_sub_window); 					% Count Mode
% result = edgeDetection(img, rule, neighbor_hood, sub_windows, pattern_lookup_matrix);	      % Pattern Mode

cannyResult = edge(mat2gray(img), "Canny");
sobelResult = edge(mat2gray(img), "Sobel");
prewittResult = edge(mat2gray(img), "Sobel");

plots_to_print = struct();
plots_to_print.("Input") = img;
plots_to_print.("Ground Truth") = cannyResult;
plots_to_print.("Plain OTCA832") = plain_otca_result;
plots_to_print.("Subwindow OTCA832") = sub_window_otca_result;
plots_to_print.("Sobel") = sobelResult;
plots_to_print.("Prewitt") = prewittResult;

plotResults(plots_to_print);
