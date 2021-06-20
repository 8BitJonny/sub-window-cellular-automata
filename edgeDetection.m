function [resultImg] = edgeDetection (img, ruleSet, neighborHood, subwindows)
	ITERATIONS = 1;
	figure(1);

	% BASED ON SUBWINDOW/NEIGHBORHOOD SIZE -> BUILD PADDING AROUND IMAGE
	biggestCoordOffset = abs(max(max(max(subwindows))));
	img = extendWithBoundaryCondition(img, biggestCoordOffset);

	nx = rows(img);
	ny = columns(img);
	newState = zeros(size(img));
	subWindowState = zeros(size(img));

	% Start & Stop Conditions for the loops
	xyStart = biggestCoordOffset+1;
	xStop = nx - biggestCoordOffset;
	yStop = ny - biggestCoordOffset;

	countOfSubwindowElements = rows(subwindows);
	baseNeighborHoodIndexes = calcIndexesFromCoords(xyStart, xyStart, ny, neighborHood);
	baseSubWindowIndexes = calcIndexesFromCoords(xyStart, xyStart, ny, subwindows);

	for iter = 1:ITERATIONS
		for ix = xyStart:xStop
			for iy = xyStart:yStop
				indexOffset = ((iy - xyStart) * ny + (ix - xyStart));
				subWindowIndexes = baseSubWindowIndexes + indexOffset;
				neighborHoodIndexes = baseNeighborHoodIndexes + indexOffset;

				subWindowState(subWindowIndexes(1,:,:)) = calcSubwindowResults(img, subWindowIndexes, countOfSubwindowElements);

				nlive = countAlive(subWindowState(neighborHoodIndexes));

				newState(ix, iy) = getRuleResult(nlive, img(ix, iy), ruleSet);

				% Reset SubWindowState
				subWindowState(subWindowIndexes(1,:,:)) = 0;
			end % loop over columns
		end % loop over rows

		img = newState;
		
		%%% Comment out to not show intermediate results
		% imshow(img);
		% pause(0.2)

	end % loop over iterations
	resultImg = img;
endfunction
