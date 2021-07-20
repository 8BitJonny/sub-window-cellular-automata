function result = calculatePerformance(edge_detection_results, empty_performance_results, detection_speeds, FAST = 0)
	algorithms = fieldnames(empty_performance_results);
	progress_bar = progressBar(length(edge_detection_results), "Calc Performance");

	baddeleys_delta_params = struct("wFunc", "x", "kPower", 2, "dist", "euc");

	%%%%%%%%%%%%%%
	%%%% PERF CALC
	[pratts_FoM root_mean_square_errors peak_signal_to_noise_ratio baddeleys_delta_metric] = deal(empty_performance_results);
	for i = 1:length(edge_detection_results)
		ground_truth = edge_detection_results{i}.("Ground Truth");
		for algo_i = 1:numel(algorithms)
			if (getappdata (progress_bar, "interrupt"))
				setappdata (progress_bar, "interrupt", false);
    			return
   			endif
			key = algorithms{algo_i};
			value = edge_detection_results{i}.(key);
			root_mean_square_errors.(key)(i) = rmse(value, ground_truth);
			peak_signal_to_noise_ratio.(key)(i) = psnr(value, ground_truth);
			baddeleys_delta_metric.(key)(i) = BDM(ground_truth, value, baddeleys_delta_params);
			if (!FAST)
				pratts_FoM.(key)(i) = prattsFigureOfMerit(ground_truth, value, true);
			end
		end
		progressBar(length(edge_detection_results) + i, "Calc Performance");
	endfor

	mean_performances = structfun(
		@(y) structfun( @(x) mean(x), y, "UniformOutput", false),
		struct(
			"PFoM", pratts_FoM,
			"RMSE", root_mean_square_errors,
			"PSNR", peak_signal_to_noise_ratio,
			% "Execution Time", detection_speeds
			"BDM", baddeleys_delta_metric
		), "UniformOutput", false
	);

	if (FAST)
		mean_performances = rmfield(mean_performances, 'PFoM')
	end
	result = mean_performances;
endfunction
