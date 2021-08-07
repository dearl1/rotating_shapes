clear
clc

coords_available = [[0, 0],
                    [0, 1],
                    [0, 2],
                    [1, 0],
                    [1, 1],
                    [1, 2],
                    [2, 0]]
   
look_for = [1, 2];
% look_for = [2, 99];


ones_where_coords_match = coords_available==look_for
two_where_coords_match = sum(ones_where_coords_match')
one_where_coord_matches = [two_where_coords_match == 2]'
find(one_where_coord_matches==1)

% sum(ones_where_coords_match)
% find(ones_where_coords_match)
% 
% disp("*************")
% sum(ones_where_coords_match')
% find(ones_where_coords_match')
% 
% find(sum(ones_where_coords_match') == 2)

if sum(ones_where_coords_match) > 0
    disp("The co-ord pair was found.")
end