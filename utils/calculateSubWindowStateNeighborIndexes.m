function result = calculateSubWindowStateNeighborIndexes(neighbor_hood_indexes, padded_img_dim)
	img_dim = size(neighbor_hood_indexes, 1) * size(neighbor_hood_indexes, 2);
	n_neighbors = size(neighbor_hood_indexes, 3);
	nI = flipud(reshape(neighbor_hood_indexes, img_dim, n_neighbors)');
	cI = reshape(floor(((1:img_dim*n_neighbors)-1)/n_neighbors)+1, n_neighbors, img_dim);
	result = sub2ind([padded_img_dim, img_dim], nI, cI)';
endfunction
