function extendedImg = extendWithBoundaryCondition (img, paddingSize)
	% BASED ON SIZE -> BUILD PADDING AROUND IMAGE
	xPadding = zeros(rows(img), paddingSize);
	img = [xPadding img xPadding];
	yPadding = zeros(paddingSize, columns(img));
	extendedImg = [yPadding; img; yPadding];
endfunction