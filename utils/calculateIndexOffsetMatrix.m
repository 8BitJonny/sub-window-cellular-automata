% (IMG_HEIGHT x Y x 1) Matrix with Index Offset for each e
function indexOffsetMatrix = calculateIndexOffsetMatrix (padded_img_height, padded_img_width, padding)
	img_height = padded_img_height - padding*2;
	img_width = padded_img_width - padding*2;
	index_matrix = reshape(1 : img_height * img_width, img_height, img_width);
	padded_index_matrix = extendWithBoundaryCondition(index_matrix, padding);

	non_null_values = padded_index_matrix(padded_index_matrix > 0);
	column_index_matrix = floor((non_null_values - 1) / img_height);
	column_index_offset_matrix = (column_index_matrix * padding * 2);

	indexOffsetMatrix = padded_index_matrix;
	indexOffsetMatrix(indexOffsetMatrix > 0) = column_index_offset_matrix + non_null_values - 1;
endfunction
