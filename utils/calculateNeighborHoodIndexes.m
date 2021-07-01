% (X x Y x NeighborHood Size) Matrix with 3D for NeighborHood Indices for each e
function neighborHoodIndexes = calculateNeighborHoodIndexes (neighborHood, indexOffsetMatrix, padded_img_width, padding)
	baseNeighborHoodIndexes = calculateIndexesFromCoords(padding, padded_img_width, neighborHood);
	neighborHoodIndexes = indexOffsetMatrix + reshape(baseNeighborHoodIndexes,1,1,size(neighborHood,1));
endfunction
