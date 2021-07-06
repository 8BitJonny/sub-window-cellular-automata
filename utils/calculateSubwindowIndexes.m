% (X x Y x SubWindows Count * Subwindow elems) Matrix with 4D for SubWindow Indices for each e
function sub_window_indexes = calculateSubwindowIndexes (sub_windows, index_offset_matrix, padded_img_width, padding)
	base_sub_window_indexes = calculateIndexesFromCoords(padding, padded_img_width, sub_windows);
	reshaped_sub_window_indexes = reshape(base_sub_window_indexes, 1, 1, size(sub_windows, 1), size(sub_windows, 3));
	sub_window_indexes = index_offset_matrix + permute(reshaped_sub_window_indexes, [1,2,4,3]);
endfunction
