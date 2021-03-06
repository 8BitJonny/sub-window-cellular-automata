function result = plotResults(plots_to_print, performances_to_print, flip_colors = true)
	clf;
	f = figure(1);

	performances_to_print_count = numfields(performances_to_print);
	plots_to_print_count = numfields(plots_to_print);
	plots_per_row = 2;
	plot_i = 0;
	plot_rows = ceil((plots_to_print_count + performances_to_print_count) / plots_per_row);
	plot_cols = plots_per_row;

	for [value, key] = plots_to_print
		plot_i = plot_i + 1;
		subplot(plot_rows, plot_cols, plot_i);
		imshow(value == !flip_colors);
		title(key);
	end

	% Plot performance Graph
	for [value, key] = performances_to_print
		labels = fieldnames(value);
		value = [struct2cell(value){:}];
		sorting_direction = ternary(strcmp(key, "RMSE") || strcmp(key, "BDM"), "descend", "ascend");
		[sorted_performance, sorted_indexes] = sort(value, sorting_direction);

		plot_i = plot_i + 1;
		subplot (plot_rows, plot_cols, plot_i);
		barh(sorted_performance);
		title(key);
		set(gca, "yTickLabel", labels(sorted_indexes,:))
		daspect("manual")
		daspect(daspect() .* [0.7 1 1])
	end
endfunction
