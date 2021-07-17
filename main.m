%%%%%%%%%%
%%%% SETUP
setup();

FAST = 0;
IMGS_TO_TEST = 200;
progress_bar = progressBar(IMGS_TO_TEST, "Loading");

% Neighborhoods need to be defined from center outwards in a clockwise spiral
load "./NeighborHoods/Moore.mat" neighbor_hood
load "./ruleLookUpTable/MooreWithCenter.mat" pattern_lookup_matrix
[gT_simple_rule, otca_832_rule] = loadRules({"C/Ground_Truth_Simple", "C/OTCA832"});
[rosin_sub_window, no_effect_sub_window] = loadSubwindows({"PLRosin", "NoEffect"});

imgs = loadImages({"TrainingSet/*"}, IMGS_TO_TEST);
% imgs = loadImages({"apple-1", "bat-1", "beetle-6", "butterfly-20", "elephant-1"});

%%%%%%%%%%%%%%%%%
%%%% EDGE DETECTION
tic;
results = {};
for i = 1:length(imgs)
	if (getappdata (progress_bar, "interrupt"))
    	return
   	endif
	img = imgs{i};

	% Calculate Ground Truth	
	gT_without_noise = edgeDetection(img, gT_simple_rule, neighbor_hood, no_effect_sub_window);

	% Apply Noise
	img = imnoise(img, "salt & pepper", 0.15);
	% img = double(imnoise(img, "speckle", 0.5) > 0.5);

	% Apply base method
	plain_otca_result = edgeDetection(img, otca_832_rule, neighbor_hood, no_effect_sub_window);
	% Apply proposed method
	sub_window_otca_result = edgeDetection(img, otca_832_rule, neighbor_hood, rosin_sub_window);
	% Denoise for State of the art methods
	denoised_img = im2double(mat2gray(im2bw (imsmooth(img, "P&M"))));
	% Apply state of the art methods
	cannyResult = edge(denoised_img, "Canny");
	sobelResult = edge(denoised_img, "Sobel");
	prewittResult = edge(denoised_img, "Prewitt");

	% Save Results
	results(i) = struct(
		"Input", img,
		"Ground Truth", gT_without_noise,
		"Plain OTCA832", plain_otca_result,
		"Subwindow OTCA832", sub_window_otca_result,
		"Canny", cannyResult,
		"Sobel", sobelResult,
		"Prewitt", prewittResult
	);
	progressBar(i, "Edge Detection");
endfor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% PERFORMANCE CALCULATION
performance = calculatePerformance(results, FAST);

time = toc();
progress_bar = progressBar(IMGS_TO_TEST*2, ["Took " sprintf("%0.2f", time) "s in total (" sprintf("%0.2f", time/IMGS_TO_TEST) "s per IMG)"]);

%%%%%%%%%%%%%%%%%%%%
%%%% RESULT PRINTING
plotResults(results{1}, performance);
