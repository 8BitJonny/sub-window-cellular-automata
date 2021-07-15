% Root Mean Square Error Calculation
function result = rmse(data,estimate)
	result = sqrt(immse(data, estimate));
end
