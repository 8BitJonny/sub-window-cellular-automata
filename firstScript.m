rule30 = struct("III", "O", "IIO", "O", "IOI", "O", "IOO", "I", ...
"OII", "I", "OIO", "I", "OOI", "I", "OOO", "O");
rule = rule30
key = 'III'
update(0+1) = getfield(rule, key);
update(0+2) = getfield(rule, 'IOO');
update(0+3) = getfield(rule, 'IIO');
lut = ones(1, 26)*255; % white background
lut(9) = 0; % map I to min gray scale level
previous = update;
a = uint8('A')
index = uint8(previous) - uint8('A') + 1;
binary = lut(index);
result(0+1,:) = binary;

result = [0,1,1; 0,0,1; 0,1,0]

figure(1)
imshow(result);
title('Rule 110 Cellular Automaton');