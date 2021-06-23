function nAlive = countAlive (matrix, dim = 1)
	nAlive = sum(matrix > 0, dim);
endfunction
