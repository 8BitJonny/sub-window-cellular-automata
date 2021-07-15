function [subwindow_results, non_zero_result_indexes] = calculateSubwindowResults (img, sub_window_indexes, count_of_sub_window_elements)
	subwindow_results = round( countAlive( img(sub_window_indexes), 4 ) / count_of_sub_window_elements );
	non_zero_result_indexes = find(subwindow_results);
endfunction
