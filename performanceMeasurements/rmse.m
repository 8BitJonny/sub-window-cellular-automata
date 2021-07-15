% Root Mean Square Error Calculation
function result = rmns(data,estimate)
	result = sqrt(immse(data, estimate));
end
