% (IMG_HEIGHT x Y x 1) Matrix with Index Offset for each e
function indexOffsetMatrix = calculateIndexOffsetMatrix (padded_img_height, padded_img_width, padding)
	img_height = padded_img_height - padding*2;
	img_width = padded_img_width - padding*2;
	index_matrix = reshape(1 : img_height * img_width, img_height, img_width);

	column_index_matrix = floor((index_matrix - 1) / img_height);
	column_index_offset_matrix = (column_index_matrix * padding * 2);

	indexOffsetMatrix = column_index_offset_matrix + index_matrix - 1;
endfunction
