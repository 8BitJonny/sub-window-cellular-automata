function extended_img = extendWithBoundaryCondition (img, padding_size)
	% BASED ON SIZE -> BUILD PADDING AROUND IMAGE
	x_padding = zeros(rows(img), padding_size);
	img = [x_padding img x_padding];
	y_padding = zeros(padding_size, columns(img));
	extended_img = [y_padding; img; y_padding];
endfunction