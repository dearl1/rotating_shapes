clear
clc

coords_available = [[0, 0],
                    [0, 1],
                    [0, 2],
                    [1, 0],
                    [1, 1],
                    [1, 2],
                    [2, 0]]
                
through_record = [1, 3, 4]

coords_available(through_record,:)=repmat([-1,-1], [3,1])