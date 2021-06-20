function result = calcSubwindowResults (img, subWindowIndexes, countOfSubwindowElements)
	result = round( countAlive(img(subWindowIndexes)) / countOfSubwindowElements );
endfunction
