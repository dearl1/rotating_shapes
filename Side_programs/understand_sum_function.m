clear
clc

qwe = [[0, 0],
       [1, 0],
       [1, 2],
       [1, 3]]
   
sum(qwe) % outputs: 3, 5

sum(qwe') % output 0, 1, 3, 4

% so sum does this: sums a column of a matrix to a single value and outputs
% as many values as there are columns