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


% practising outputting coordinates on grid
figure(1)
clf
scatter(store(1).record_1(:,1),store(1).record_1(:,2))
xlim([0, 5])
ylim([0, 5])
set(gca, 'XTick', 0:5)
set(gca, 'YTick', 0:5)

store

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
    

% sorting store struct so items are similar if they are similar

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


% trying to find all placements of all orientations
for shape_count=1:size(all_orientations,2) % for shape_count=1:28
    
    widen=5-max(all_orientations(shape_count).record_1(:,1));
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


% made all_placements struct from all_orientations struct
count=1;

for j=1:size(all_orientations,2)
    for i = 1:numel(fieldnames(all_orientations))
        if length(all_orientations(j).(genvarname([strcat('record_',num2str(i))]))) ~= 0
            all_placements(count).record_1=all_orientations(j).(genvarname([strcat('record_',num2str(i))]));
            count=count+1;
        end
    end
end  


% finding the number of orientations per shape

number_of_orientations=zeros(1,size(store,2));

for j=1:size(store,2)
    for i=1:8
        if length(store(j).(genvarname([strcat('record_',num2str(i))]))) ~= 0
            number_of_orientations(j)=number_of_orientations(j)+1;
        end
    end
end

% number_of_orientations


% finding the number of placements per orientation

number_of_placements=zeros(1,size(all_orientations,2));

for j=1:size(all_orientations,2)
    for i=1:numel(fieldnames(all_orientations))
        if length(all_orientations(j).(genvarname([strcat('record_',num2str(i))]))) ~= 0
            number_of_placements(j)=number_of_placements(j)+1;
        end
    end
end

% number_of_placements


% finding the first index that each shape occurs in all_placements

all_placements_borders=[1];

for shape_count=1:size(store,2)-1
    all_placements_borders=[all_placements_borders,all_placements_borders(shape_count)+sum(number_of_placements(1:number_of_orientations(1)))];
    
    number_of_placements(1:number_of_orientations(1))=[];
    number_of_orientations(1)=[];
end

all_placements_borders

% sum(number_of_placements(1:sum(number_of_orientations(1:8))))+1

save('variables')


load('variables')

all_placements_borders_base=all_placements_borders;
careful=[all_placements_borders(2:end),size(all_placements,2)];

whole_puzzle=1
go=true

while 1
%     for whole_puzzle=1:size(store,2)
        
    while go==true & all_placements_borders(whole_puzzle)<careful(whole_puzzle)-1
    
        through_record=[];
        
        for i=1:size(all_placements(all_placements_borders(whole_puzzle)).record_1,1) % for i=1:size(all_placements(all_placements_borders_base(whole_puzzle)).record_1,1)
            for through=1:size(coords_available,1)
                if coords_available(through,:)==all_placements(all_placements_borders(whole_puzzle)).record_1(i,:)
                   
                    through_record=[through_record, through];
%                     coords_available(through,:)=[-1,-1];
        
                end
            end
        end
        
        if length(through_record)==size(all_placements(all_placements_borders_base(whole_puzzle)).record_1,1)
            coords_available(through_record,:)=repmat([-1,-1], [length(through_record),1]);
            go=false;
            
%                 shape_record=;
        else
            all_placements_borders(whole_puzzle)=all_placements_borders(whole_puzzle)+1;
            
%             % testing progress
%             all_placements_borders
        end
        
    end
    
    % testing progress
    all_placements_borders
    
    if go==false & whole_puzzle==size(store,2)
        break
    elseif go==true
        all_placements_borders(whole_puzzle:end)=all_placements_borders_base(whole_puzzle:end);
%         whole_puzzle=whole_puzzle-1;    
        all_placements_borders(whole_puzzle-1)=all_placements_borders(whole_puzzle-1)+1;
        whole_puzzle=1;
        coords_available=coords_available_base;
    else
        whole_puzzle=whole_puzzle+1;
        go=true;
    end
        
%     end
end

% below gives the index in all_placements to all 9 of the 'shape, orientation, placement's that solve the puzzle
all_placements_borders


a=[1,2;
    3,4;
    5,6;
    7,8;
    9,10];

a([1,3],:)=repmat([0,0],[2,1]);
a

careful=[all_placements_borders(2:end),size(all_placements,2)]

% repmat(a,[2,1])



% testing if 141th placement fits in

through_record=[];

for i=1:size(all_placements(141).record_1,1)
    for through=1:size(coords_available,1)
        if coords_available(through,:)==all_placements(141).record_1(i,:)
           
            through_record=[through_record, through];
%             coords_available(through,:)=[-1,-1];

        end
    end
end

through_record
        
