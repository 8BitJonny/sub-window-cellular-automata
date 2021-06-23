function indexes = calculateIndexesFromCoords (img_padding_size, ny, coordinatesMatrix)
	% Flip the y axis coordinates so that -1 is down and 1 is up
	coordinatesMatrix(:,2,:) = -coordinatesMatrix(:,2,:);
	% Calc Matrix with seperate X and Y indexes
	xAndYIndexes = [img_padding_size + 1, img_padding_size + 1] + coordinatesMatrix;
	% Combine all seperate X and Y indexes into one Index
	indexes = ((xAndYIndexes(:,1,:) - 1) * ny) + xAndYIndexes(:,2,:);
endfunction