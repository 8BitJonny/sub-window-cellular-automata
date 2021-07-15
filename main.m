%%%%%%%%%%
%%%% SETUP
pkg load image
addpath([genpath("./utils") ":./performanceMeasurements"]);
clf;

% Neighborhoods need to be defined from center outwards in a clockwise spiral
load "./NeighborHoods/Moore.mat" neighbor_hood
load "./ruleLookUpTable/MooreWithCenter.mat" pattern_lookup_matrix
[gT_simple_rule, otca_832_rule] = loadRules({"C/Ground_Truth_Simple", "C/OTCA832"});
[rosin_sub_window, no_effect_sub_window] = loadSubwindows({"PLRosin", "NoEffect"});

imgs = loadImages({"blinker", "lena-binary", "apple-1", "bat-1", "beetle-6", "butterfly-20", "smiley"});
img = imgs.("bat-1"); % Image to be used

%%%%%%%%%%%%%%%%%
%%%% CALCULATIONS
gT_without_noise = edgeDetection(img, gT_simple_rule, neighbor_hood, no_effect_sub_window);
img = imnoise(img, "salt & pepper", 0.10);

plain_otca_result = edgeDetection(img, otca_832_rule, neighbor_hood, no_effect_sub_window);
sub_window_otca_result = edgeDetection(img, otca_832_rule, neighbor_hood, rosin_sub_window);

denoised_img = mat2gray(im2bw (imsmooth(img, "P&M")));
cannyResult = edge(denoised_img, "Canny");
sobelResult = edge(denoised_img, "Sobel");
prewittResult = edge(denoised_img, "Prewitt");

%%%%%%%%%%%%%%%%%%%%
%%%% RESULT PRINTING
plots_to_print = struct();
plots_to_print.("Input") = img;
plots_to_print.("Ground Truth") = gT_without_noise;
plots_to_print.("Plain OTCA832") = plain_otca_result;
plots_to_print.("Subwindow OTCA832") = sub_window_otca_result;
plots_to_print.("Canny") = cannyResult;
plots_to_print.("Sobel") = sobelResult;
plots_to_print.("Prewitt") = prewittResult;

plotResults(plots_to_print, true);
