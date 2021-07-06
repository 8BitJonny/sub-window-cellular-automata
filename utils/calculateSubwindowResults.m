function result = calculateSubwindowResults (img, sub_window_indexes, count_of_sub_window_elements)
	result = round( countAlive( img(sub_window_indexes), 4 ) / count_of_sub_window_elements );
endfunction
