function result = plotResults(plots_to_print, fast = false)
	clf;
	f = figure(1);
	set(f, "color", [0.3 0.3 0.3]);

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
		title(key, "color", [1 1 1]);
	end

	[pratts_FoM root_mean_square_errors peak_signal_to_noise_ratio] = deal(zeros(0));
	% Calculate Performance
	for [value, key] = plots_to_print
		if (!strcmp(key, "Input") && !strcmp(key, "Ground Truth"))
			if (!fast)
				pratts_FoM(end+1) = prattsFigureOfMerit(plots_to_print.("Ground Truth"), value);
			end
			root_mean_square_errors(end+1) = rmse(value, plots_to_print.("Ground Truth"));
			peak_signal_to_noise_ratio(end+1) = psnr(value, plots_to_print.("Ground Truth"));
		endif
	end

	performances_to_print = struct();
	performances_to_print.("RMSE") = root_mean_square_errors;
	performances_to_print.("PSNR") = peak_signal_to_noise_ratio;
	performances_to_print.("PFoM") = pratts_FoM;

	% Plot performance Graph
	white_labels = @(labels, fn, parser) fn (@(x) sprintf (["\\color{white}{" parser "}"], x), labels, "uniformoutput", false);
	for [value, key] = performances_to_print
		if (fast && strcmp(key, "PFoM"))
			continue
		endif
		plot_i = plot_i + 1;
		subplot (plot_rows, plot_cols, plot_i);
		[sorted_performance, sorted_indexes] = sort(value);
		h = barh(sorted_performance);
		title(key, "color", [1 1 1]);
		set(gca, "yTickLabel", white_labels(fieldnames(plots_to_print)(3:end)(sorted_indexes,:), @cellfun, "%s"))
		set(gca, "xTickLabel", white_labels(get(gca, "XTick"), @arrayfun, "%.2f"))
	end
endfunction
