function result = visualizePattern(pattern)
	result = reshape (postpad (flip (str2num (dec2bin (pattern) (:))), 9, 0, 1) ([7, 6, 5, 8, 1, 4, 9, 2, 3]), 3, 3);
endfunction