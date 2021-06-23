% (X x Y x SubWindows Count * Subwindow elems) Matrix with 4D for SubWindow Indices for each e
function subwindowIndexes = calculateSubwindowIndexes (subwindows, indexOffsetMatrix, padded_img_width, padding)
	baseSubWindowIndexes = calculateIndexesFromCoords(padding, padded_img_width, subwindows);
	subwindowIndexes = indexOffsetMatrix + permute(reshape(baseSubWindowIndexes,1,1,4,8), [1,2,4,3]);
endfunction
