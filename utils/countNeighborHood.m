function aliveNeighbors = countNeighborHood (x,y,world,n_h)
	aliveNeighbors = 0;
	for index = 1:length(n_h)
        neighbor = n_h{index};
		neighborPixel = getPixel(x + neighbor(1), y + neighbor(2), world);
		aliveNeighbors = aliveNeighbors + neighborPixel;
	endfor
endfunction