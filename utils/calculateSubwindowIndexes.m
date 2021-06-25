% (X x Y x SubWindows Count * Subwindow elems) Matrix with 4D for SubWindow Indices for each e
function subwindowIndexes = calculateSubwindowIndexes (subwindows, indexOffsetMatrix, padded_img_width, padding)
	baseSubWindowIndexes = calculateIndexesFromCoords(padding, padded_img_width, subwindows);
	reshapedSubWindowIndexes = reshape(baseSubWindowIndexes, 1, 1, size(subwindows, 1), size(subwindows, 3));
	subwindowIndexes = indexOffsetMatrix + permute(reshapedSubWindowIndexes, [1,2,4,3]);
endfunction
