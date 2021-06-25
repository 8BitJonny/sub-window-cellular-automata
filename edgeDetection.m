function [resultImg] = edgeDetection (img, rule, neighborHood, subwindows)
	% CONSTANTS
	ITERATIONS = 1;
	IMG_HEIGHT = rows(img);
	IMG_WIDTH = columns(img);
	N_SUBWINDOWS = columns(subwindows);
	N_SUBWINDOW_PARTS = rows(subwindows);

	%%% SETUP
	figure(1);
	getNextStateFn = configureGetNextStateFn(rule);

	% BASED ON SUBWINDOW/NEIGHBORHOOD SIZE -> BUILD PADDING AROUND IMAGE
	padding = abs(max(max(max(subwindows))));
	padded_img = extendWithBoundaryCondition(img, padding);
	padded_img_height = rows(padded_img);
	padded_img_width = columns(padded_img);
	padded_img_dim = padded_img_width * padded_img_height;
	
	%%% Subwindows and Neighborhood cells are given in relative coordinates like (-1, 0)
	%%% We therefore have to compute the real cell index for when the center cell is e.g. (2,2) which would
	%%% result in: (-1,0) + (2,2) = (1,2). The calculation is a bit more complex since we have a padding around
	%%% the image and since we have to handle the cases around the edges
	% Calculate the indexOffsetMatrix based on the img padding
	indexOffsetMatrix = calculateIndexOffsetMatrix(padded_img_height, padded_img_width, padding);
	% Calculate all needed subwindow and neighborhood cell indexes based on the indexOffsetMatrix
	neighborHoodIndexes = calculateNeighborHoodIndexes(neighborHood, indexOffsetMatrix, padded_img_width, padding);
	subWindowIndexes = calculateSubwindowIndexes(subwindows, indexOffsetMatrix, padded_img_width, padding);
	subWindowStateIndexes = calculateSubWindowStateIndexes(subWindowIndexes, IMG_HEIGHT, IMG_WIDTH, padded_img_dim);

	% Pre Allocating Values
	subWindowState = spalloc(padded_img_dim, IMG_WIDTH*IMG_HEIGHT, padded_img_dim * N_SUBWINDOWS);
	cur_img_state = padded_img;
	aliveNeighborMatrix = padded_img;

	for iter = 1:ITERATIONS
		% Calculate all N_SUBWINDOWS Subwindow States for each cell
		subWindowState(subWindowStateIndexes) = calculateSubwindowResults(padded_img, subWindowIndexes, N_SUBWINDOW_PARTS);
		% Use the Subwindow States as a NeighborHood to count how many neighbor cells are alive for each cell
		% The result is a 2D IMG_HEIGHT x IMG_WIDTH Matrix where each cell value is amount of alive neighbors
		aliveNeighborMatrix = reshape(countAlive(subWindowState > 0), IMG_HEIGHT, IMG_WIDTH);

		% From N alive neighbor cells and the center cell's initial state, calculate the next state
		cur_img_state = getNextStateFn(extendWithBoundaryCondition(aliveNeighborMatrix, padding), padded_img);
		
		%%% Comment out to not show intermediate results
		% imshow(cur_img_state);
		% pause(0.2)

	end % loop over iterations
	resultImg = cur_img_state;
endfunction
