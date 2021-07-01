function patternLookupMatrix = generatePatternLookupTable (neighborHoodCoords)
	neighborHoodSize = abs(max(max(max(neighborHoodCoords)))) * 2 + 1;
	% Add center bc we currently define our neighborhood without it
	maxPatternCount = 2**size(neighborHoodCoords, 1)
	neighborHoodCoords = [[0 0]; neighborHoodCoords];
	% maxPatternCount = 2**size(neighborHoodCoords, 1)
	% maxPatternCount = 3

	indexOffsetMatrix = calculateIndexOffsetMatrix(neighborHoodSize, neighborHoodSize, 0);
	% Calculate all needed subwindow and neighborhood cell indexes based on the indexOffsetMatrix
	neighborHoodIndexes = calculateNeighborHoodIndexes(neighborHoodCoords, indexOffsetMatrix, neighborHoodSize, 0);
	neighborHoodIndexes = reshape(neighborHoodIndexes(2,2,:), size(neighborHoodCoords, 1), 1);
	aliveNeighbors = zeros(3,3);
	patternLookupTable = struct();
	patternLookupMatrix = [];
	temp = struct();
	uniquePatternList = [];

	r = @(i) reshape(i(neighborHoodIndexes), 9, 1);
	neighborHood2RuleID = @(n) bin2dec(num2str(fliplr(n')));
	for i = 1:maxPatternCount
	% for i = [6, 12, 24, 48, 96, 192, 258, 384]
		i = bitshift(i,1);
		if isfield(patternLookupTable, num2str(i))
			continue
		endif
		aliveNeighbors(neighborHoodIndexes) = reshape(postpad(flip(str2num(dec2bin(i)(:))), 9, 0, 1), neighborHoodSize, neighborHoodSize);
		% Rotate 90°, 180°, 270°
		m = aliveNeighbors;
		r1 = rotdim(aliveNeighbors, -1);
		r2 = rotdim(aliveNeighbors, -2);
		r3 = rotdim(aliveNeighbors, -3);
		mx = fliplr(aliveNeighbors); % Mirror x
		mxr1 = rotdim(mx, -1);
		mxr2 = rotdim(mx, -2);
		mxr3 = rotdim(mx, -3);
		my = flipud(aliveNeighbors); % Mirror y
		myr1 = rotdim(my, -1);
		myr2 = rotdim(my, -2);
		myr3 = rotdim(my, -3);
		mxy = flipud(mx); % Mirror y
		mxyr1 = rotdim(mxy, -1);
		mxyr2 = rotdim(mxy, -2);
		mxyr3 = rotdim(mxy, -3);

		patternIndexs = fliplr([r(m) r(r1) r(r2) r(r3) r(mx) r(mxr1) r(mxr2) r(mxr3) r(my) r(myr1) r(myr2) r(myr3) r(mxy) r(mxyr1) r(mxyr2) r(mxyr3)]');
		patternIDs = reshape(bin2dec(num2str(patternIndexs)), 1, size(bin2dec(num2str(patternIndexs)), 1));
		smallestPatternID = min(patternIDs);
		uniquePatternList = [smallestPatternID uniquePatternList];
		for h = patternIDs
			patternLookupTable.(num2str(h)) = smallestPatternID;
		endfor
	endfor
	for [val, key] = patternLookupTable
		if isfield(temp, num2str(val))
			temp.(num2str(val)) = [str2num(key) temp.(num2str(val))];
		else
			temp.(num2str(val)) = [str2num(key)];
		endif
		patternLookupMatrix(str2num(key) + 1) = val;
	endfor

	v = @(i) reshape(postpad(flip(str2num(dec2bin(i)(:))), 9, 0, 1)([7 6 5 8 1 4 9 2 3]), 3, 3);
	for [val, key] = temp
		vM = [];
		for k = val
			vM = [vM [-1; -1; -1] v(k)];
		endfor
	endfor
	save "./ruleLookUpTable/MooreWithoutCenter2.mat" patternLookupMatrix
endfunction