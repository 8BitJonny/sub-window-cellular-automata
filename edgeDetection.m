function [resultImg] = edgeDetection (img, ruleSet, neighborHood, subwindows)
	% BASED ON SUBWINDOW/NEIGHBORHOOD SIZE -> BUILD PADDING AROUND IMAGE
	biggestCoordOffset = abs(max(max(max(subwindows))))
	img = extendWithBoundaryCondition(img, biggestCoordOffset);

	iterations = 1;
	nx = rows(img);
	ny = columns(img);
	newState = zeros(size(img));
	subWindowState = zeros(size(img));
	figure(1);

	% multiDimF = @(x, f) f(f(x));
	% subWindowX = subwindows(1,1,:)
	% subWindowY = subwindows(1,2,:)
	% subWMinX = multiDimF (subWindowX, @min);
	% subWMaxX = multiDimF (subWindowX, @max);
	% subWMinY = multiDimF (subWindowY, @min);
	% subWMaxY = multiDimF (subWindowY, @max);
	% subwindowNeighborHood = zeros (subWMaxX - subWMinX + 1, subWMaxY - subWMinY + 1);

	function re = getSubwindowResult (x,y,world,subwindow)
  		totalCellsInSubwindow = length(subwindow);
  		aliveCells = countNeighborHood(x,y,world,subwindow);
  		if (aliveCells / totalCellsInSubwindow > 0.5)
  			re = 1;
		elseif (aliveCells / totalCellsInSubwindow == 0.5)
			re = round(rand(1));
		else
			re = 0;
		endif
	endfunction


	for iter = 1:iterations
		for ix = biggestCoordOffset+1:(nx - biggestCoordOffset)
			for iy = biggestCoordOffset+1:(ny - biggestCoordOffset)
				neighborHoodIndexes = calcIndexesFromCoords(ix, iy, ny, neighborHood);
				subWindowIndexes = calcIndexesFromCoords(ix, iy, ny, subwindows);
				subWindowState(:,:,:) = 0;

				subWindowState(subWindowIndexes(1,:,:)) = round( sum(img(subWindowIndexes) > 0) / rows(subwindows) );
				% Compute subwindows
				% for index = 1:length(subwindows)
    %     			subwindow = subwindows{index};
    %     			subwindowNeighborHood(subwindow{1}(1)+2:subwindow{1}(2)+2) = getSubwindowResult(ix, iy, img, subwindow);
				% endfor
				% Cache subwindows

				nlive = sum(subWindowState(neighborHoodIndexes) > 0);
				% nlive = countNeighborHood(2,2,subwindowNeighborHood,neighborHood);
				newState(ix, iy) = getfield(ruleSet, [mat2str(nlive) "-" mat2str(img(ix, iy))]);
			end % loop over columns
		end % loop over rows

		img = newState;
		
		% Comment out to not show intermediate results
		imshow(img);
		pause(0.2)

	end % loop over iterations
	resultImg = img;
endfunction