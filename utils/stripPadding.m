function result = stripPadding(matrix, padding)
	new_row_range = 1+padding : size(matrix, 1)-padding;
	new_column_range = 1+padding : size(matrix, 2)-padding;
	result = matrix(new_row_range, new_column_range);
endfunction
