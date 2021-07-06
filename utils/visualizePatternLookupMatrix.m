function result = visualizePatternLookupMatrix (pattern_lookup_matrix)
	unique_patterns = size(unique(pattern_lookup_matrix(pattern_lookup_matrix > -1)), 2);
	result = permute(reshape(str2num(fliplr(dec2bin(permute(unique(pattern_lookup_matrix(pattern_lookup_matrix > -1)), [3,1,2])))(:,[7, 6, 5, 8, 1, 4, 9, 2, 3])(:)), unique_patterns, 3, 3), [2,3,1]);
	result(:,4,:,:) = reshape(repelem(unique(pattern_lookup_matrix(pattern_lookup_matrix > -1)),3),3,1,unique_patterns);
endfunction