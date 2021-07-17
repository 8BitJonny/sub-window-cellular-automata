function result = calculatePerformance(edge_detection_results, progress_bar_ref, FAST = 0)
	algorithms = fieldnames(
		edge_detection_results{1}
	)(!cellfun(
		@(x) (strcmp(x, "Input") || strcmp(x, "Ground Truth")),
		fieldnames(edge_detection_results{1})
	));

	%%%%%%%%%%%%%%
	%%%% PERF CALC
	[pratts_FoM root_mean_square_errors peak_signal_to_noise_ratio] = deal(struct());
	for i = 1:length(edge_detection_results)
		ground_truth = edge_detection_results{i}.("Ground Truth");
		for algo_i = 1:numel(algorithms)
			key = algorithms{algo_i};
			value = edge_detection_results{i}.(key);
			if (i == 1)
				[pratts_FoM.(key) root_mean_square_errors.(key) peak_signal_to_noise_ratio.(key)] = deal(zeros(0));
			endif
			root_mean_square_errors.(key)(end+1) = rmse(value, ground_truth);
			peak_signal_to_noise_ratio.(key)(end+1) = psnr(value, ground_truth);
			if (!FAST)
				pratts_FoM.(key)(end+1) = prattsFigureOfMerit(ground_truth, value);
			end
		end
		waitbar ((length(edge_detection_results) + i) / (length(edge_detection_results) * 2), progress_bar_ref, "Calc Performance")
	endfor

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
	result = mean_performances;
endfunction
