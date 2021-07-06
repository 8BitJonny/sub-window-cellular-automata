function n_alive = countAlive (matrix, dim = 1)
	n_alive = sum(matrix > 0, dim);
endfunction
