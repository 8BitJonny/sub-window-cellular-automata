% The Rules are described in a M x 2 matrix where first column describes how many neighbor cell live
% the second colum describes if the center cell lives and the value at that pos in the matrix describes
% the next state of the center cell.
% Because of Octave's / MatLab's One Indexing we have to add 1 to every index
function result = getRuleResult (x,y,ruleSet)
	result = ruleSet(x+1, y+1);
endfunction
