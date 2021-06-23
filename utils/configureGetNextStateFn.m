% The Rules are described in a 18 Bit Value
% 
% NeighborHood sum    |   8   |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
% --------------------|-------|-------|-------|-------|-------|-------|-------|-------|-------|
% Central pixel value | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 |
% --------------------|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
% Next State          | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 |
%
% The above table shows the Ruleset for the popular Game of Life. When the last row is converted into binary
% it equals 224 and this is how the rule is passed around or stored.
% When querying what the next state should be, the following calculation gives us the bitIndex we need to look at
%
% Neighborhood Sum * 2 + Central pixel value + 1
function result = configureGetNextStateFn (rule)
	result = @(aliveNeighborMatrix, padded_img) bitget(rule, aliveNeighborMatrix * 2 + padded_img + 1);
endfunction
