function [result_img] = edgeDetection (img, rule, neighbor_hood, sub_windows, MODE, pattern_lookup_table = false, debug = false, MAX_ITERATIONS = 1)
	% CONSTANTS
	[no_effect_sub_window] = loadSubwindows({"NoEffect"});
	IMG_HEIGHT = rows(img);
	IMG_WIDTH = columns(img);
	IMG_DIM = IMG_WIDTH * IMG_HEIGHT;
	N_SUBWINDOWS = columns(sub_windows);
	N_SUBWINDOW_PARTS = rows(sub_windows);

	%%% SETUP
	getNextStateFn = configureGetNextStateFn(rule, MODE);

	% BASED ON SUBWINDOW/NEIGHBORHOOD SIZE -> BUILD PADDING AROUND IMAGE
	padding = abs(max(max(max(sub_windows))));
	padded_img = extendWithBoundaryCondition(img, padding);
	padded_img_height = rows(padded_img);
	padded_img_width = columns(padded_img);
	padded_img_dim = padded_img_width * padded_img_height;
	
	%%% Subwindows and Neighborhood cells are given in relative coordinates like (-1, 0)
	%%% We therefore have to compute the real cell index for when the center cell is e.g. (2,2) which would
	%%% result in: (-1,0) + (2,2) = (1,2). The calculation is a bit more complex since we have a padding around
	%%% the image and since we have to handle the cases around the edges
	% Calculate the indexOffsetMatrix based on the img padding
	index_offset_matrix = calculateIndexOffsetMatrix(padded_img_height, padded_img_width, padding);
	% Calculate all needed subwindow and neighborhood cell indexes based on the indexOffsetMatrix
	neighbor_hood_indexes = calculateNeighborHoodIndexes(neighbor_hood, index_offset_matrix, padded_img_height, padding);
	sub_window_indexes = calculateSubwindowIndexes(sub_windows, index_offset_matrix, padded_img_height, padding);
	no_effect_sub_window_indexes = calculateSubwindowIndexes(no_effect_sub_window, index_offset_matrix, padded_img_height, padding);
	sub_window_state_indexes = calculateSubWindowStateIndexes(sub_window_indexes, IMG_HEIGHT, IMG_WIDTH, padded_img_dim);
	no_effect_sub_window_state_indexes = calculateSubWindowStateIndexes(no_effect_sub_window_indexes, IMG_HEIGHT, IMG_WIDTH, padded_img_dim);

	sub_window_state_neighbor_indexes = calculateSubWindowStateNeighborIndexes(neighbor_hood_indexes, padded_img_dim);

	% Pre Allocating Values
	sub_window_state = spalloc(padded_img_dim, IMG_WIDTH*IMG_HEIGHT, padded_img_dim * N_SUBWINDOWS);
	cur_img_state = padded_img;
	old_img_state = padded_img;
	alive_neighbor_matrix = padded_img;

	for iter = 1:MAX_ITERATIONS
		old_img_state = cur_img_state;
		% Calculate all N_SUBWINDOWS Subwindow States for each cell
		% THIS LINE USING CUR_IMG BREAKS IN ITERATION 2 BECAUSE NO WITH AN EDGE MAP THE SUBWINDOW AGGREGATION CALCULATES ALL ZEROS
		if (iter == 1)
			sub_window_indexes_to_be_used = sub_window_indexes;
			sub_window_state_indexes_to_be_used = sub_window_state_indexes;
			sub_window_parts = N_SUBWINDOW_PARTS;
		else
			sub_window_indexes_to_be_used = no_effect_sub_window_indexes;
			sub_window_state_indexes_to_be_used = no_effect_sub_window_state_indexes;
			sub_window_parts = 1;
		endif
		[subwindow_results, non_zero_result_indexes] = calculateSubwindowResults(cur_img_state, sub_window_indexes_to_be_used, sub_window_parts, sub_window_state_indexes_to_be_used);
		sub_window_state(sub_window_state_indexes(non_zero_result_indexes)) = subwindow_results(non_zero_result_indexes);

		if (strcmp(MODE, 'PATTERN_MODE'))
			cur_img_state_1d = reshape(stripPadding(cur_img_state, padding), IMG_DIM, 1);
			neighbor_hood_state_with_center = [full(sub_window_state(sub_window_state_neighbor_indexes)) cur_img_state_1d];
			neighbor_hood_patterns = matrixDim2Binary(neighbor_hood_state_with_center, [IMG_HEIGHT IMG_WIDTH]);
			neighbor_hood_pattern_ids = pattern_lookup_table(neighbor_hood_patterns + 1);

			% From the neighborHoodPattern, calculate the next state
			cur_img_state = getNextStateFn(extendWithBoundaryCondition(neighbor_hood_pattern_ids, padding));
		elseif (strcmp(MODE, 'COUNT_MODE_TCA') || strcmp(MODE, 'COUNT_MODE_OTCA'))			% Use the Subwindow States as a NeighborHood to count how many neighbor cells are alive for each cell
			% The result is a 2D IMG_HEIGHT x IMG_WIDTH Matrix where each cell value is amount of alive neighbors
			alive_neighbor_matrix = reshape(countAlive(sub_window_state), IMG_HEIGHT, IMG_WIDTH);

			% From N alive neighbor cells and the center cell's initial state, calculate the next state
			cur_img_state = getNextStateFn(extendWithBoundaryCondition(alive_neighbor_matrix, padding), padded_img);
		endif
		if (all(all(cur_img_state == old_img_state)))
			if (debug)
				break_after_iter = iter - 1
			endif
			break
		endif

		sub_window_state(:) = 0;
		
		%%% Comment out to not show intermediate results
		% imshow(cur_img_state);
		% pause(0.2)

	end % loop over iterations

	% Remove boundary condition
	result_img = stripPadding(cur_img_state, padding);
endfunction
