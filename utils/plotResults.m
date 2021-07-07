function result = plotResults(plots_to_print)
	f = figure(1);
	set(f, "color", [0.3 0.3 0.3]);

	plots_to_print_count = numfields(plots_to_print);
	plots_per_row = 2;
	plot_i = 0;
	plot_rows = ceil(plots_to_print_count / plots_per_row);
	plot_cols = plots_per_row;

	for [value, key] = plots_to_print
		plot_i = plot_i + 1;
		subplot (plot_rows, plot_cols, plot_i);
		imshow(value);
		title(key, "color", [1 1 1]);
	end;
endfunction
