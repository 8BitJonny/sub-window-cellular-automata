%%%%%%%%%%
%%%% SETUP
pkg load image
addpath(genpath("./utils"));
set(0, "defaultfigurecolor", [0.3 0.3 0.3]);
clf;
progress_bar = waitbar(0);
FAST = 0;
IMGS_TO_TEST = 20;

% Neighborhoods need to be defined from center outwards in a clockwise spiral
load "./NeighborHoods/Moore.mat" neighbor_hood
load "./ruleLookUpTable/MooreWithCenter.mat" pattern_lookup_matrix
[gT_simple_rule, otca_832_rule] = loadRules({"C/Ground_Truth_Simple", "C/OTCA832"});
[rosin_sub_window, no_effect_sub_window] = loadSubwindows({"PLRosin", "NoEffect"});

imgs = loadImages({"TrainingSet/*"}, IMGS_TO_TEST);
% imgs = loadImages({"apple-1", "bat-1", "beetle-6", "butterfly-20", "elephant-1"});

%%%%%%%%%%%%%%%%%
%%%% CALCULATIONS
tic;
results = {};
for i = 1:length(imgs)
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
	waitbar (i / (length(imgs) * 2), progress_bar, "Edge Detection");
endfor

algorithms = fieldnames(results{1})(!cellfun(@(x) (strcmp(x, "Input") || strcmp(x, "Ground Truth")), fieldnames(results{1})));

%%%%%%%%%%%%%%
%%%% PERF CALC
[pratts_FoM root_mean_square_errors peak_signal_to_noise_ratio] = deal(struct());
for i = 1:length(results)
	ground_truth = results{i}.("Ground Truth");
	for algo_i = 1:numel(algorithms)
		key = algorithms{algo_i};
		value = results{i}.(key);
		if (i == 1)
			[pratts_FoM.(key) root_mean_square_errors.(key) peak_signal_to_noise_ratio.(key)] = deal(zeros(0));
		endif
		root_mean_square_errors.(key)(end+1) = rmse(value, ground_truth);
		peak_signal_to_noise_ratio.(key)(end+1) = psnr(value, ground_truth);
		if (!FAST)
			pratts_FoM.(key)(end+1) = prattsFigureOfMerit(ground_truth, value);
		end
	end
	waitbar ((length(imgs) + i) / (length(results) * 2), progress_bar, "Calc Performance")
endfor
time = toc();
waitbar (1, progress_bar, ["Took " sprintf("%0.2f", time) "s in total (" sprintf("%0.2f", time/IMGS_TO_TEST) "s per IMG)"])

mean_performances = structfun(
	@(y) structfun( @(x) mean(x), y, "UniformOutput", false),
	struct(
		"PFoM", pratts_FoM,
		"RMSE", root_mean_square_errors,
		"PSNR", peak_signal_to_noise_ratio
	), "UniformOutput", false
);

if (FAST)
	mean_performances = rmfield(mean_performances, 'PFoM')
end

%%%%%%%%%%%%%%%%%%%%
%%%% RESULT PRINTING
plotResults(results{2}, mean_performances);
