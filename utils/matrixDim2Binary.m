function result = matrixDim2Binary(matrix, output_dim = false)
	result = bin2dec(num2str(matrix));
	if (output_dim)
		result = reshape(result, output_dim(1), output_dim(2));
	endif
endfunction
