function sub_window_state_indexes = calculateSubWindowStateIndexes (sub_window_indexes, img_height, img_width, padded_img_dim)
	img_dim = img_height * img_width;
	index_matrix = reshape(1:img_dim, img_height, img_width);
	zero_index_matrix = index_matrix - 1;
	dimension_index_offset_matrix = zero_index_matrix * padded_img_dim;
	sub_window_state_indexes = sub_window_indexes(:,:,:,1) + dimension_index_offset_matrix;
endfunction
