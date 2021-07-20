%%%%%%%%%%
%%%% SETUP
setup();

FAST = 0;
IMGS_TO_TEST = 20;
progress_bar = progressBar(IMGS_TO_TEST, "Loading");

% Neighborhoods need to be defined from center outwards in a clockwise spiral
load "./NeighborHoods/Moore.mat" neighbor_hood
load "./ruleLookUpTable/MooreWithCenter.mat" pattern_lookup_matrix
[gT_simple_rule, otca_832_rule, tca_112_rule] = loadRules({"C/Ground_Truth_Simple", "C/OTCA832", "C/TCA112"});
[rosin_sub_window, no_effect_sub_window] = loadSubwindows({"PLRosin", "NoEffect"});

imgs = loadImages({"TrainingSet/*"}, IMGS_TO_TEST);
% imgs = loadImages({"apple-1", "bat-1", "beetle-6", "butterfly-20", "elephant-1"});

%%%%%%%%%%%%%%%%%
%%%% EDGE DETECTION
tic;
results = {}; empty_performance_results = {}; detection_speeds = {};
algo_types = ["Plain OTCA832"; "Subwindow OTCA832"; "Plain TCA112"; "Subwindow TCA112"; "Canny"; "Sobel"; "Prewitt"; "Roberts"];
for i = 1:rows (algo_types)
  empty_performance_results.(strtrim(algo_types(i,:))) = zeros(1, IMGS_TO_TEST);
endfor
detection_speeds = empty_performance_results;
for i = 1:length(imgs)
	if (getappdata (progress_bar, "interrupt"))
		setappdata (progress_bar, "interrupt", false);
    	return
   	endif
	img = imgs{i};

	% Calculate Ground Truth	
	gT_without_noise = edgeDetection(img, gT_simple_rule, neighbor_hood, no_effect_sub_window, "COUNT_MODE_OTCA");

	% Apply Noise
	img = imnoise(img, "salt & pepper", 0.15);
	% img = double(imnoise(img, "speckle", 0.5) > 0.5);

	% OTCA 832, base and modified version
	tic;
	plain_otca_832_result = edgeDetection(img, otca_832_rule, neighbor_hood, no_effect_sub_window, "COUNT_MODE_OTCA");
	detection_speeds.("Plain OTCA832")(i) = toc;tic;
	sub_window_otca_832_result = edgeDetection(img, otca_832_rule, neighbor_hood, rosin_sub_window, "COUNT_MODE_OTCA");
	detection_speeds.("Subwindow OTCA832")(i) = toc;

	% TCA 112, base and modified version
	tic;
	plain_tca_112_result = edgeDetection(img, tca_112_rule, neighbor_hood, no_effect_sub_window, "COUNT_MODE_TCA");
	detection_speeds.("Plain TCA112")(i) = toc;tic;
	sub_window_tca_112_result = edgeDetection(img, tca_112_rule, neighbor_hood, rosin_sub_window, "COUNT_MODE_TCA");
	detection_speeds.("Subwindow TCA112")(i) = toc;

	% Denoise for State of the art methods
	tic;
	denoised_img = im2double(mat2gray(im2bw (imsmooth(img, "P&M"))));
	not_denoised_img = im2double(mat2gray(im2bw(img)));
	standard_algo_input_img = not_denoised_img;
	smoothing_time = toc;
	% Apply state of the art methods
	tic;
	cannyResult = edge(standard_algo_input_img, "Canny");
	detection_speeds.("Canny")(i) = toc + smoothing_time;tic;
	sobelResult = edge(standard_algo_input_img, "Sobel");
	detection_speeds.("Sobel")(i) = toc + smoothing_time;tic;
	prewittResult = edge(standard_algo_input_img, "Prewitt");
	detection_speeds.("Prewitt")(i) = toc + smoothing_time;tic;
	robertsResult = edge(standard_algo_input_img, "Roberts");
	detection_speeds.("Roberts")(i) = toc + smoothing_time;

	% Save Results
	results(i) = struct(
		"Input", img,
		"Ground Truth", gT_without_noise,
		"Plain OTCA832", plain_otca_832_result,
		"Subwindow OTCA832", sub_window_otca_832_result,
		"Plain TCA112", plain_tca_112_result,
		"Subwindow TCA112", sub_window_tca_112_result,
		"Canny", cannyResult,
		"Sobel", sobelResult,
		"Prewitt", prewittResult,
		"Roberts", robertsResult
	);
	progressBar(i, "Edge Detection");
endfor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% PERFORMANCE CALCULATION
performance = calculatePerformance(results, empty_performance_results, detection_speeds, FAST)

time = toc();
progress_bar = progressBar(IMGS_TO_TEST*2, ["Took " sprintf("%0.2f", time) "s in total (" sprintf("%0.2f", time/IMGS_TO_TEST) "s per IMG)"]);

%%%%%%%%%%%%%%%%%%%%
%%%% RESULT PRINTING
plotResults(results{1}, performance, 0);
