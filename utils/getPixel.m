cache = struct();

function pixl = getPixel (x,y, world)
	lookupKey = [x "-" y]
	if (isfield(cache, lookupKey))
		pixl = getField(cache, lookupKey)
	else
		if (x < 1) || (y < 1) || (x > rows(world)) || (y > columns(world))
  			pixl = 0;
		else
			pixl = world(x,y);
		endif
		setField(cache, lookupKey, pixl)
	endif
endfunction