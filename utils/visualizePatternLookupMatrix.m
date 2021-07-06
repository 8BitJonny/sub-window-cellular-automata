function result = visualizePatternLookupMatrix (patternLookupMatrix)
	uniquePatterns = size(unique(patternLookupMatrix(patternLookupMatrix > -1)), 2);
	result = permute(reshape(str2num(fliplr(dec2bin(permute(unique(patternLookupMatrix(patternLookupMatrix > -1)), [3,1,2])))(:,[7, 6, 5, 8, 1, 4, 9, 2, 3])(:)), uniquePatterns, 3, 3), [2,3,1]);
	result(:,4,:,:) = reshape(repelem(unique(patternLookupMatrix(patternLookupMatrix > -1)),3),3,1,uniquePatterns);
endfunction