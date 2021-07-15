pkg load image
addpath ("./utils");addpath ("./performanceMeasurements");
clf;

% Neighborhoods need to be defined from center outwards in a clockwise spiral
load "./NeighborHoods/Moore.mat" neighbor_hood
load "./ruleLookUpTable/MooreWithCenter.mat" pattern_lookup_matrix

gT_simple_rule = load("./RuleSets/CountBased/Ground_Truth_Simple.mat").("rule")
test_rule = load("./RuleSets/PatternBased/TestPattern.mat").("rule");
otca_832_rule = load("./RuleSets/CountBased/OTCA832.mat").("rule");

rosin_sub_window = load("./SubWindows/PLRosin.mat").("sub_windows");
no_effect_sub_window = load("./SubWindows/NoEffect.mat").("sub_windows");

lena_img = imread("./Images/lena-binary.png");
blinker_img = imread("./Images/blinker.png");
shapes = {"apple-1", "bat-1", "beetle-6", "beetle-10", "bone-17", "butterfly-20"};
shape_img = imread(["./Images/",shapes{2},".gif"]);
% Image to be used
img = shape_img;

if (isbool(img))
	img = im2double(img, "indexed");
endif

gT_without_noise = edgeDetection(img, gT_simple_rule, neighbor_hood, no_effect_sub_window);
img = imnoise(img, "salt & pepper", 0.10);

plain_otca_result = edgeDetection(img, otca_832_rule, neighbor_hood, no_effect_sub_window); 						% Count Mode
sub_window_otca_result = edgeDetection(img, otca_832_rule, neighbor_hood, rosin_sub_window); 					% Count Mode
% result = edgeDetection(img, rule, neighbor_hood, sub_windows, pattern_lookup_matrix);	      % Pattern Mode

denoised_img = mat2gray(im2bw (imsmooth(img, "P&M")));
cannyResult = edge(denoised_img, "Canny");
sobelResult = edge(denoised_img, "Sobel");
prewittResult = edge(denoised_img, "Prewitt");

plots_to_print = struct();
plots_to_print.("Input") = img;
plots_to_print.("Ground Truth") = gT_without_noise;
plots_to_print.("Plain OTCA832") = plain_otca_result;
plots_to_print.("Subwindow OTCA832") = sub_window_otca_result;
plots_to_print.("Canny") = cannyResult;
plots_to_print.("Sobel") = sobelResult;
plots_to_print.("Prewitt") = prewittResult;

plotResults(plots_to_print, true);
