function result = plotResults(plots_to_print, fast = false)
	clf;
	f = figure(1);
	set(f, "color", [0.3 0.3 0.3]);
	set(0, "defaulttextcolor", "white");
	set(0, "defaultaxesycolor", "white");
	set(0, "defaultaxesxcolor", "white");

	performances_to_print_count = ternary(fast, 2, 3);
	plots_to_print_count = numfields(plots_to_print);
	plots_per_row = 2;
	plot_i = 0;
	plot_rows = ceil((plots_to_print_count + performances_to_print_count) / plots_per_row);
	plot_cols = plots_per_row;

	for [value, key] = plots_to_print
		plot_i = plot_i + 1;
		subplot (plot_rows, plot_cols, plot_i);
		imshow(value);
		title(key);
	end

	% Calculate Performance
	[pratts_FoM root_mean_square_errors peak_signal_to_noise_ratio] = deal(zeros(0));
	ground_truth = plots_to_print.("Ground Truth");
	for [value, key] = plots_to_print
		if (!strcmp(key, "Input") && !strcmp(key, "Ground Truth"))
			root_mean_square_errors(end+1) = rmse(value, ground_truth);
			peak_signal_to_noise_ratio(end+1) = psnr(value, ground_truth);
			if (!fast)
				pratts_FoM(end+1) = prattsFigureOfMerit(ground_truth, value);
			end
		endif
	end

	performances_to_print = struct(
		"RMSE", root_mean_square_errors,
		"PSNR", peak_signal_to_noise_ratio,
		"PFoM", pratts_FoM
	);

	% Plot performance Graph
	for [value, key] = performances_to_print
		if (fast && strcmp(key, "PFoM"))
			continue
		endif
		sorting_direction = ternary(strcmp(key, "RMSE"), "descend", "ascend");
		[sorted_performance, sorted_indexes] = sort(value, sorting_direction);

		plot_i = plot_i + 1;
		subplot (plot_rows, plot_cols, plot_i);
		barh(sorted_performance);
		title(key);
		set(gca, "yTickLabel", fieldnames(plots_to_print)(3:end)(sorted_indexes,:))
	end
endfunction
