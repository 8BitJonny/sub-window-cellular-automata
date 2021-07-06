function result = matrixDim2Binary(matrix, outputDim = false)
	result = bin2dec(num2str(matrix));
	if (outputDim)
		result = reshape(result, outputDim(1), outputDim(2));
	endif
endfunction
