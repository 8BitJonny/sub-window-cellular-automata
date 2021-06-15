function [resultImg] = edgeDetection (img, ruleSet, neighborHood)
	iterations = 20;
	nx = rows(img);
	ny = columns(img);
	newState = zeros(size(img));
	figure(1);

	for iter = 1:iterations
		for ix = 1:nx
			for iy = 1:ny
				nlive = countNeighborHood(ix,iy,img,neighborHood);
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