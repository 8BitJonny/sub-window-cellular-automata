function result = stripPadding(matrix, padding)
	newRowRange = 1+padding : size(matrix, 1)-padding;
	newColumnRange = 1+padding : size(matrix, 2)-padding;
	result = matrix(newRowRange, newColumnRange);
endfunction
