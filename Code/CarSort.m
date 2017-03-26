%% Sort function based on obj.x
function [L B] = CarSort(A)
[~, index] = sort(A(3,:), 'descend');
A = A(:,index);
Lane1 = A(1,find(A(2,:)==1));
Lane2 = A(1,find(A(2,:)==2));
Lane3 = A(1,find(A(2,:)==3));
Lane4 = A(1,find(A(2,:)==4));

%Here we are indexing each car sorted by position and assigning to a
%respective lane vector
L(1) = length(Lane1 ~=0);
L(2) = length(Lane2 ~=0);
L(3) = length(Lane3 ~=0);
L(4) = length(Lane4 ~=0);
B{1} = Lane1(1:end);
B{2} = Lane2(1:end);
B{3} = Lane3(1:end);
B{4} = Lane4(1:end);
end