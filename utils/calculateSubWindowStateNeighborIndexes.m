function result = calculateSubWindowStateNeighborIndexes(neighborHoodIndexes, padded_img_dim)
	img_dim = size(neighborHoodIndexes, 1) * size(neighborHoodIndexes, 2);
	n_neighbors = size(neighborHoodIndexes, 3);
	nI = flipud(reshape(neighborHoodIndexes, img_dim, n_neighbors)');
	cI = reshape(floor(((1:img_dim*n_neighbors)-1)/n_neighbors)+1, n_neighbors, img_dim);
	result = sub2ind([padded_img_dim, img_dim], nI, cI)';
endfunction
