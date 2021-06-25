function subWindowStateIndexes = calculateSubWindowStateIndexes (subWindowIndexes, img_height, img_width, padded_img_dim)
	img_dim = img_height * img_width;
	indexMatrix = reshape(1:img_dim, img_height, img_width);
	zeroIndexMatrix = indexMatrix - 1;
	dimensionIndexOffsetMatrix = zeroIndexMatrix * padded_img_dim;
	subWindowStateIndexes = subWindowIndexes(:,:,:,1) + dimensionIndexOffsetMatrix;
endfunction
