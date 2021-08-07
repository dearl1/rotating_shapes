clear
clc

coords_available = [[0, 0],
                    [0, 1],
                    [0, 2],
                    [1, 0],
                    [1, 1],
                    [1, 2],
                    [2, 0]]
                
coords_available_base=coords_available;
                
through_record = [1, 3, 4]

coords_available(through_record,:)=repmat([-1,-1], [3,1])

% % 
through_record_store = through_record;
through_record = [];

coords_available(through_record_store,:) = coords_available_base(through_record_store,:)