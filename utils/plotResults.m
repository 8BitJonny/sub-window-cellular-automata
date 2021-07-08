function result = plotResults(plots_to_print)
	f = figure(1);
	set(f, "color", [0.3 0.3 0.3]);

	plots_to_print_count = numfields(plots_to_print);
	plots_per_row = 2;
	plot_i = 0;
	plot_rows = ceil((plots_to_print_count + 1) / plots_per_row)
	plot_cols = plots_per_row;

	for [value, key] = plots_to_print
		plot_i = plot_i + 1;
		subplot (plot_rows, plot_cols, plot_i);
		imshow(value);
		title(key, "color", [1 1 1]);
		if (!strcmp(key, "Input") && !strcmp(key, "Ground Truth"))
			performance_measure(plot_i - 2) = figureOfMerit(value, plots_to_print.("Ground Truth"));
		endif
	end;

	% Plot Performance Measurement Graph
	subplot (plot_rows, plot_cols, plot_i + 1, "color", "w");
	hold on
	[sorted_performance, sorted_indexes] = sort(performance_measure);
	h = barh(sorted_performance);
	title("PFoM", "color", [1 1 1]);
	white_labels = @(labels, fn, parser) fn (@(x) sprintf (["\\color{white}{" parser "}"], x), labels, "uniformoutput", false);
	set(gca, "yTickLabel", white_labels(fieldnames(plots_to_print)(3:end)(sorted_indexes,:), @cellfun, "%s"))
	set(gca, "xTickLabel", white_labels(get(gca, "XTick"), @arrayfun, "%.2f"))
endfunction
