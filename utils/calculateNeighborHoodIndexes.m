% (X x Y x NeighborHood Size) Matrix with 3D for NeighborHood Indices for each e
function neighbor_hood_indexes = calculateNeighborHoodIndexes (neighbor_hood, index_offset_matrix, padded_img_width, padding)
	base_neighbor_hood_indexes = calculateIndexesFromCoords(padding, padded_img_width, neighbor_hood);
	neighbor_hood_indexes = index_offset_matrix + reshape(base_neighbor_hood_indexes,1,1,size(neighbor_hood,1));
endfunction
