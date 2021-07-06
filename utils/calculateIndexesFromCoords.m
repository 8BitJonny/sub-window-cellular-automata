function indexes = calculateIndexesFromCoords (img_padding_size, ny, coordinates_matrix)
	% Flip the y axis coordinates so that -1 is down and 1 is up
	coordinates_matrix(:,2,:) = -coordinates_matrix(:,2,:);
	% Calc Matrix with seperate X and Y indexes
	x_and_y_indexes = [img_padding_size + 1, img_padding_size + 1] + coordinates_matrix;
	% Combine all seperate X and Y indexes into one Index
	indexes = ((x_and_y_indexes(:,1,:) - 1) * ny) + x_and_y_indexes(:,2,:);
endfunction