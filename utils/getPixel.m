function pixl = getPixel (x,y, world)
  	if (x < 1) || (y < 1) || (x > rows(world)) || (y > columns(world))
  		pixl = 0;
	else
		pixl = world(x,y);
	endif
endfunction