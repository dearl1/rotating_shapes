%{
clear
clc

% reading the data
data=csvread('Shapes.csv');

% setting borders between shapes
border=find(data(:,1)==2);

% finding coordinates of all shapes

for count=1:length(border)+1
    store(count).record_1=[];

    if count==1
        height=1:border(1)-1;
    elseif count==length(border)+1
        height=border(end)+1:size(data,1);
    else
        height=border(count-1)+1:border(count)-1;
    end
    
    for i=flip(height)
        for j=1:size(data,2)
            if data(i,j)==1
                store(count).record_1 = [store(count).record_1;[j-1,(0+height(end)-i)]];
            end
        end
    end
    
%     store(count).record_1
end

%{
% practising outputting coordinates on grid
figure(1)
clf
scatter(store(1).record_1(:,1),store(1).record_1(:,2))
xlim([0, 5])
ylim([0, 5])
set(gca, 'XTick', 0:5)
set(gca, 'YTick', 0:5)
%}

% store

% source_coords=store(1).record_1()

%{
hold on

scatter([1,2],[0,1],'x')
%}

angle=90;
fig_num=2;

for shape_count=[1:length(border)+1] % for shape_count=[1:length(border)+1]
%     fprintf('We are doing shape %.0f',shape_count)
    for flip_count=1:2
        
        if flip_count==1
            source_coords=store(shape_count).record_1();
            count_array=[2:4];
        else
            source_coords=[-store(shape_count).record_1(:,1),store(shape_count).record_1(:,2)];
            count_array=[5:8];
        end
        
        for count=count_array
            
            % rotating the shape
            store(shape_count).(genvarname([strcat('record_',num2str(count))])) (:,1) = source_coords(:,1)*cosd(angle*(count-1)) + source_coords(:,2)*sind(angle*(count-1));
            store(shape_count).(genvarname([strcat('record_',num2str(count))])) (:,2) = source_coords(:,2)*cosd(angle*(count-1)) - source_coords(:,1)*sind(angle*(count-1));
            
            % moving the rotated coordinates so the bottom left is at the origin
            store(shape_count).(genvarname([strcat('record_',num2str(count))])) (:,1) = store(shape_count).(genvarname([strcat('record_',num2str(count))]))(:,1) + - min(store(shape_count).(genvarname([strcat('record_',num2str(count))]))(:,1));
            store(shape_count).(genvarname([strcat('record_',num2str(count))])) (:,2) = store(shape_count).(genvarname([strcat('record_',num2str(count))]))(:,2) + - min(store(shape_count).(genvarname([strcat('record_',num2str(count))]))(:,2));
            
            % displaying coords of all shapes
            
%             figure(fig_num)
%             clf
%             scatter(store(shape_count).(genvarname([strcat('record_',num2str(count))]))(:,1),store(shape_count).(genvarname([strcat('record_',num2str(count))]))(:,2))
%             xlim([0, 5])
%             ylim([0, 5])
%             set(gca, 'XTick', 0:5)
%             set(gca, 'YTick', 0:5)

            % displaying coords of just shape 3
                
%             if shape_count==3
%                 figure(fig_num)
%                 clf
%                 scatter(store(shape_count).(genvarname([strcat('record_',num2str(count))]))(:,1),store(shape_count).(genvarname([strcat('record_',num2str(count))]))(:,2))
%                 xlim([0, 5])
%                 ylim([0, 5])
%                 set(gca, 'XTick', 0:5)
%                 set(gca, 'YTick', 0:5)
%             end
            
            fig_num=fig_num+1;
            
        end
    end
end
    

% sorting store struct first by sorting x values and sorting y values in the same way
% then sorting x and y values together
% this makes it easy to see if a rotation of a shape is the same as another rotation of this same shape

for j=1:length(border)+1
    for i = 1:8
%         store(j).(genvarname([strcat('record_',num2str(i))])) (:,1) = sort(store(j).(genvarname([strcat('record_',num2str(i))])) (:,1));
        
        % ordering store struct items according to x values
        [store(j).(genvarname([strcat('record_',num2str(i))]))(:,1), order] = sort(store(j).(genvarname([strcat('record_',num2str(i))])) (:,1));
        store(j).(genvarname([strcat('record_',num2str(i))])) (:,2) = store(j).(genvarname([strcat('record_',num2str(i))])) (order,2);

        % ordering store struct items according to x & y coord values
        temp_sum=sum(store(j).(genvarname([strcat('record_',num2str(i))]))');
        [ordered, order]=sort(temp_sum);
        store(j).(genvarname([strcat('record_',num2str(i))]))=store(j).(genvarname([strcat('record_',num2str(i))]))(order,:);
        
    end
end


% only keeping non-duplicated coords in store

for shape_count=[1:length(border)+1] % for shape_count=[1:length(border)+1]

    for count_duplicate=8:-1:2
        
        duplicate=false;
        
        for i=count_duplicate-1:-1:1
            if store(shape_count).(genvarname([strcat('record_',num2str(count_duplicate))])) == store(shape_count).(genvarname([strcat('record_',num2str(i))]))
                duplicate=true;
                break
            end
        end
        
        if duplicate == true
            store(shape_count).(genvarname([strcat('record_',num2str(count_duplicate))]))=[];
        end
        
    end
end


% putting all orientations from store struct into a new struct called all_orientations

count=1;

for j=1:length(border)+1
    for i = 1:8
        if length(store(j).(genvarname([strcat('record_',num2str(i))]))) ~= 0
            all_orientations(count).record_1=store(j).(genvarname([strcat('record_',num2str(i))]));
            count=count+1;
        end
    end
end  

% all_orientations % outputs: 1x28 struct
% size(all_orientations) % outputs: 1, 28

% trying to find all placements of all orientations
for shape_count=1:size(all_orientations,2) % for shape_count=1:28
    
    widen=5-max(all_orientations(shape_count).record_1(:,1)); % if a shape has an x co-ord at 5 then it spans the entire width of the 6 block board
    % so widen would be 5-5=0
    heighten=5-max(all_orientations(shape_count).record_1(:,2));
    
    count=1;
    for j=0:widen
        for i=0:heighten
            all_orientations(shape_count).(genvarname([strcat('record_',num2str(count))]))(:,2)=all_orientations(shape_count).record_1(:,2)+i;
            all_orientations(shape_count).(genvarname([strcat('record_',num2str(count))]))(:,1)=all_orientations(shape_count).record_1(:,1)+j;
            count=count+1;
        end
    end
    
%     % displaying coords after I've found the different possible placements
%     
%     if shape_count==28
%         for show_count=1:count-1
%             figure(show_count)
%             clf
%             scatter(all_orientations(shape_count).(genvarname([strcat('record_',num2str(show_count))]))(:,1),all_orientations(shape_count).(genvarname([strcat('record_',num2str(show_count))]))(:,2))
%             xlim([0, 5])
%             ylim([0, 5])
%             set(gca, 'XTick', 0:5)
%             set(gca, 'YTick', 0:5)
%         end
%     end

end


% making array of coordinates that are available to take

coords_available=[];

count=1;

for j=0:5
    for i=0:5
        coords_available(count,:)=[j,i];
        count=count+1;
    end
end

% removing the stumpers coordinates from the coordinates that are available to take

stumpers=[0,0; 0,2; 1,4; 2,3; 4,1; 5,3; 5,4];

for i=1:size(stumpers,1)
    for through=1:size(coords_available,1)
        if coords_available(through,:)==stumpers(i,:)
            coords_available(through,:)=[-1,-1];
        end
    end
end

% we can reset the coords_available matrix with the coords_available_base matrix
coords_available_base=coords_available;

% at this point in the code: all_orientations is a 1x28 struct with 36 fields 
% i.e. one of the shapes went up to ' all_orientations(i).record_36 ' because it was small and so it had many placements


% make 'all_placements' struct from 'all_orientations' struct
count=1;

% size(all_orientations,2) % this outputs: 28
    % Each of the 9 shapes was rotated and, after getting rid of duplicates, there were 28 'shape rotations'
% numel(fieldnames(all_orientations)) % this outputs: 36
    % of all the 28 'shape rotations' the one which has the most freedom to
    % move around the board can be placed 36 times (because it's just a
    % single block!)


for j=1:size(all_orientations,2) % for each of the 28 'shape rotations'
    for i = 1:numel(fieldnames(all_orientations)) % numel return the number of elements in an array (not the same as the function 'size')
        if length(all_orientations(j).(genvarname([strcat('record_',num2str(i))]))) ~= 0 % not all of the 'shape rotations' had up to 36 placements
                % for example, all but 1 of the .record_36 fields are 0.
                % This is what this if statement is checking.
                
            all_placements(count).record_1=all_orientations(j).(genvarname([strcat('record_',num2str(i))]));
            count=count+1;
        end
    end
end  

% at this point in the code: the all_placements struct is of size 1x625 and
% has 1 field which is .record_1


% finding the number of orientations per shape

% remember that store is a struct of size 1x9 which has 8 fields
    % it has the non-duplicate rotations of all 9 shapes.
number_of_orientations=zeros(1,size(store,2)); % an array of 9 zeros

for j=1:size(store,2) % j goes from 1 through 9
    for i=1:8
        if length(store(j).(genvarname([strcat('record_',num2str(i))]))) ~= 0
            number_of_orientations(j)=number_of_orientations(j)+1;
        end
    end
end

% number_of_orientations


% finding the number of placements per orientation

size(all_orientations,2) % outputs: 28. Because there are 28 'shape rotations'.
% When I say 'shape rotation' that is synonymous with 'an orientation' - as in: all_orientations has 28 elements

number_of_placements=zeros(1,size(all_orientations,2)); % an array of 28 zeros.

for j=1:size(all_orientations,2) % j goes from 1 through 28
    for i=1:numel(fieldnames(all_orientations)) % i goes from 1 through 36
        if length(all_orientations(j).(genvarname([strcat('record_',num2str(i))]))) ~= 0
            number_of_placements(j)=number_of_placements(j)+1;
        end
    end
end

% number_of_placements


% finding the first index that each shape occurs in all_placements

all_placements_borders=[1];

% size(store,2) % outputs 9 because store is a 1x9 struct because there are 9 shapes.

for shape_count=1:size(store,2)-1 % shape_count goes from 1 through 8
    all_placements_borders=[all_placements_borders,all_placements_borders(shape_count) + sum( number_of_placements(1:number_of_orientations(1)) ) ];
    
    % Number_of_orientations(1) is the number of orientations (aka shape rotations) that the first shape has
    % The first, second and third orientations might have 2, 1 and 5
        % placements as indicated by the array number_of_placements being equal to [2, 1, 5, ...]
    % So the array all_placements_borders gets a new element which is the
        % index of the place in the 625 (is it?) placements where the next shape starts
    
    % the below 2 lines shave off the start of the 2 arrays so that the in
        % the next iteration of the for loop the next shape is dealt with
    number_of_placements(1:number_of_orientations(1))=[];
    number_of_orientations(1)=[];
end

% all_placements_borders

% sum(number_of_placements(1:sum(number_of_orientations(1:8))))+1

save('variables') % once this is run: this line of code and above can be commented out and the rest of the code can be run without having to run the above.
%}


% second half of code
%{
clear
clc

load('variables')

all_placements_borders_base=all_placements_borders;
careful=[all_placements_borders(2:end), size(all_placements,2) + 1 ]; % this: 'size(all_placements,2) + 1' makes us go right up to the last placement in the struct all_placements in the code below

whole_puzzle=1;
store_all_placements_borders = [];

disp("Starting main loop to try and find all the possible solutions")
while 1 % for temp_i = 1
%     tic
    go=true;
    
    
    while go==true & all_placements_borders(whole_puzzle) <= careful(whole_puzzle)-1 % I think there needs to be a <= here
        
%         disp("   check 1")
    
        through_record=[];
        
        num_coords_in_placement = size( all_placements(all_placements_borders(whole_puzzle)).record_1, 1 );
        for i=1:num_coords_in_placement % i goes from 1 through to the number of co-ords in a certain shape
            look_for_this_co_ord_pair = all_placements(all_placements_borders(whole_puzzle)).record_1(i,:);
            
            % look at: 'Side_programs/test_look_for_co-ord_pair_in_coords_available.m' to understand the below section of code
            ones_where_coords_match = coords_available==look_for_this_co_ord_pair; % same size as coords_available and has ones where either x or y from look_for_this_co_ord_pair match with an x or y in coords_available
            two_where_coords_match = sum(ones_where_coords_match'); % size is 1x36 (if you have a 6x6=36 board). Has a 2 at the location where both x and y match together.
            one_where_coord_matches = [two_where_coords_match == 2]'; % size is 36x1 (if you have a 6x6=36 board). Has zeros everywhere apart from a 1 at the location where both x and y match together.

            if sum(one_where_coord_matches) == 0 % 'look_for_this_co_ord_pair' doesn't fit in the puzzle so the whole placement won't fit
                all_placements_borders(whole_puzzle)=all_placements_borders(whole_puzzle)+1; % move on to the next placement of the current shape to see if it will fit in the puzzle

                break % break out of the for loop because there's no point testing if the other co-ord pairs fit since we know at least one pair doesn't fit
            
            elseif sum(one_where_coord_matches) == 1 % 'look_for_this_co_ord_pair' does fit in the puzzle
                through_record=[ through_record, find(one_where_coord_matches==1) ]; % store what index in coords_available has co-ords which match: 'look_for_this_co_ord_pair'
            end

        end
        
        
        if length(through_record) == num_coords_in_placement % if this is true then we got through the above for loop without being broken out of it.
                % So that means all of the co-ord pairs in the current placement fit in the puzzle.

            coords_available(through_record,:)=repmat([-1,-1], [length(through_record),1]); % replace all the co-ord pairs in coords_available which match with the co-ord pairs in the full placement with: [-1, -1]
            go=false; % the current placement fits into the puzzle so don't try and fit another placement of the same shape into the puzzle

        end
        
    end
  
    
    if go==false & whole_puzzle==size(store,2) % If whole_puzzle == 9 then the shape that we last tried to fit into the puzzle was the 9th and last shape
            % And if go == false that means that a placement of this 9th and last shape did successfully fit into the puzzle.
        
%         disp("   check 2")
%         fprintf("   whole_puzzle: %.0f \n", whole_puzzle)

        disp("   **************************")
        disp("                             ")
        disp("Found a solution. See the 'all_placements_borders' array for the indices in the all_placements struct that give the placements which are a solution.")
        disp("all_placements_borders is...")
        disp(all_placements_borders)
        disp("")
        disp("all_placements_borders_base is...")
        disp(all_placements_borders_base)
        
        % I need to save the current all_placements_borders array in a big array.
        store_all_placements_borders = [store_all_placements_borders;
                                        all_placements_borders];
        
        all_placements_borders(whole_puzzle)=all_placements_borders(whole_puzzle)+1; % move on to the next placement of the current shape to see if it will fit in the puzzle
        
        % We need to reset the coords_available array so that the co-ords which the 'last successfully placed shape' (which was the 9th shape) took are
            % made available again for the 9th shape to be placed down again.
        coords_available( through_record , : ) = coords_available_base( through_record , : );
        % Btw: through_record is an array which currently has what indices in coords_available has co-ords which match the 9th shape
        
        % Now we go down to print how long it took to find this solution and then we go back to 'while 1' to do another big loop to look for
            % another solution.
        
    elseif go==true % if go == true then that means that the shape which we just tried to fit into the puzzle above did not fit in
            % So we need to redo the placing down of the previous shape. If redoing the placing down of this shape doesn't work this same section of code
            % (albeit at a later iteration) will make us redo the placing down of the shape before this one as well - and so on.
            
%         disp("   check 3")
%         fprintf("   whole_puzzle: %.0f \n", whole_puzzle)
%         fprintf("   all_placements_borders: %.0f \n", all_placements_borders)
        
        if whole_puzzle == 1 % This means that we have just tried to fit the first shape into the puzzle and it didn't fit which must mean 
            % it's impossible to solve the puzzle or we have finished finding all the solutions.
            
            disp("We have been bumped up to the first shape and it could not be placed.")
            break
            
        end
        
        % new code
        
        all_placements_borders(whole_puzzle) = all_placements_borders_base(whole_puzzle); % this will mean that in the future, when we try to place the
            % current shape (which didn't fit at the moment), we will test all the placements of this shape from the start.
        all_placements_borders(whole_puzzle-1)=all_placements_borders(whole_puzzle-1)+1; % we will try to place the next placement along in the shape that was most recently successfully placed.
        
        % We need to reset the coords_available array so that the co-ords which the 'last successfully placed shape' took are made available again
            % for this 'last successfully placed shape' to be placed down again.
        coords_available( through_record_store(whole_puzzle-1).record_1 , : ) = coords_available_base( through_record_store(whole_puzzle-1).record_1 , : );
            
        whole_puzzle = whole_puzzle - 1; % now we can restart in this while loop: 'while go==true & all_placements_borders(whole_puzzle)<careful(whole_puzzle)-1'
        
        % end of new code
        
    else % go == false but whole_puzzle is not yet 9. So we need to try and place the next shape.
        
%         disp("   check 4")
        
        % Required for new code:
        % We need to store what through_record is just in case the current position of this successfully placed shape needs to be given a new position
            % due to subsequent shapes not being able to fit
%         through_record_store(whole_puzzle, :) = through_record;
        through_record_store(whole_puzzle).record_1 = through_record;
        
        whole_puzzle=whole_puzzle+1;
        go=true;
        
    end

end

% fprintf("Time required to find solution: %.2f\n", toc)
disp("Finished main loop")

% store_all_placements_borders is an array of all of the all_placements_borders which give the index in all_placements to all 9 of the
    % 'shape, orientation, placement's that solve the puzzle


% save("variables_2")
%}

% save("variables_2")


% output solution(s) to figure(s)

clear
clc

load("variables_2")

fig_num = 0;

disp("Beginning plotting")
for solution = [1:3]

    fig_num = fig_num + 1;
    figure(fig_num)
    clf
    hold on

    % make struct called solution_coords with all the placements that solve the puzzle
    plot_this_all_placements_borders = store_all_placements_borders(solution, :);

    clear solution_coords
    for i = 1:length(plot_this_all_placements_borders)
        solution_coords(i).record_1 = all_placements( plot_this_all_placements_borders(i) ).record_1;
    end

    % for color codes I have used: https://www.rapidtables.com/web/color/RGB_Color.html
    % plot the stumpers

    set(gca, 'Units', 'Points');
    axpos = get(gca,'Position');
    fig_width = axpos(3);
    fig_height = axpos(4);
    fig_min_length = min([fig_width, fig_height]);

    % MarkerSize is the area of the markers
    MarkerSize = ( (fig_min_length/5)^0.5 - 0.3 )^2;

    stumper_color_burlywood = [222, 184, 135]/255;
    color = stumper_color_burlywood;
    plot(stumpers(:, 1), stumpers(:, 2), 'o', 'MarkerSize', MarkerSize, 'MarkerEdgeColor', color, 'MarkerFaceColor', color)

    % define shape colors
    dark_blue = [0, 0, 255];
    green = [0, 128, 0];
    red = [255, 0, 0];
    orange = [255, 69, 0];
    grey = [169, 169, 169];
    chocolate = [210, 105, 30];
    yellow = [255, 255, 0];
    purple = [128, 0, 128];
    light_blue = [30, 144, 255];

    shape_colors_temp = [dark_blue; green; red; orange; grey; chocolate; yellow; purple; light_blue];
    shape_colors = shape_colors_temp/255;

    % plot the shapes
    for i = 1:size(solution_coords, 2)
        color = shape_colors(i, :);        
        x = solution_coords(i).record_1 (:, 1);
        y = solution_coords(i).record_1 (:, 2);
        plot(x, y, 's', 'MarkerSize', MarkerSize, 'MarkerEdgeColor', color, 'MarkerFaceColor', color);
    end

    
    xlim([0, 5])
    ylim([0, 5])

    % remove axes
    set(gca, 'XTick', [])
    set(gca, 'YTick', [])


end

disp("Finished plotting")









