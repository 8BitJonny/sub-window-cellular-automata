function result = calculateSubwindowResults (img, subWindowIndexes, countOfSubwindowElements)
	result = round( countAlive( img(subWindowIndexes), 4 ) / countOfSubwindowElements );
endfunction
