function [resultImg] = edgeDetection (img, ruleSet, neighborHood, subwindows)
	% BASED ON SUBWINDOW/NEIGHBORHOOD SIZE -> BUILD PADDING AROUND IMAGE
	biggestCoordOffset = abs(max(max(max(subwindows))));
	img = extendWithBoundaryCondition(img, biggestCoordOffset);

	iterations = 1;
	nx = rows(img);
	ny = columns(img);
	newState = zeros(size(img));
	subWindowState = zeros(size(img));
	figure(1);

	stringLookUp = "0123456789";
	toString = @(num) stringLookUp(num+1);

	countOfSubwindowElements = rows(subwindows);
	countAlive = @(matrix) sum(matrix > 0);
	calcSubwindowResults = @(img, subWindowIndexes, countOfSubwindowElements) round( countAlive(img(subWindowIndexes)) / countOfSubwindowElements );

	for iter = 1:iterations
		for ix = biggestCoordOffset+1:(nx - biggestCoordOffset)
			for iy = biggestCoordOffset+1:(ny - biggestCoordOffset)
				neighborHoodIndexes = calcIndexesFromCoords(ix, iy, ny, neighborHood);
				subWindowIndexes = calcIndexesFromCoords(ix, iy, ny, subwindows);

				subWindowState(subWindowIndexes(1,:,:)) = calcSubwindowResults(img, subWindowIndexes, countOfSubwindowElements);

				nlive = countAlive(subWindowState(neighborHoodIndexes));

				newState(ix, iy) = getfield(ruleSet, [toString(nlive) "-" toString(img(ix, iy))]);

				% Reset SubWindowState
				subWindowState(subWindowIndexes(1,:,:)) = 0;
			end % loop over columns
		end % loop over rows

		img = newState;
		
		% Comment out to not show intermediate results
		% imshow(img);
		% pause(0.2)

	end % loop over iterations
	resultImg = img;
endfunction