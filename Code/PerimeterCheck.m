%% Checks left and right lane for obstructing cars
function [lp, rp, lv, rv] = PerimeterCheck(Array,A,i,j)
    global lagD
    d = 3*lagD + 1; 
    lv = 1;
    rv = 1;
    if i < 4;
        A{i+1} = [];
        A{i+1} = find(Array(2,:)==i+1);
    end
    
    if i > 1;
        A{i-1} = [];
        A{i-1} = find(Array(2,:)==i-1);
    end
    if i == 1
        rp = 1;
        if isempty(find(Array(3,A{i+1}) < Array(3,A{i}(j))+ d & Array(3,A{i+1}) > Array(3,A{i}(j)) - d))== 1
            lp = 0;
        else
            lp = 1;
        end

        %%
        if mean(Array(4, find(Array(3,A{i+1}) >= Array(3,A{i}(j))))) > mean(Array(4, find(Array(3,A{i}) >= Array(3,A{i}(j))))) 
            lv = 0;
        else
            lv = 1;
            if isempty(find(Array(3,A{i+1}) >= Array(3,A{i}(j))))== 1
                lv = 0;
            end
        end   
    elseif i == 4
        lp = 1;  
         if isempty(find(Array(3,A{i-1}) < Array(3,A{i}(j))+ d & Array(3,A{i-1}) > Array(3,A{i}(j))- d))== 1
            rp = 0;
         else
            rp = 1;

         end
         %%
         if mean(Array(4, find(Array(3,A{i-1}) >= Array(3,A{i}(j))))) > mean(Array(4, find(Array(3,A{i}) >= Array(3,A{i}(j))))) 
            rv = 0;
        else
            rv = 1;
            if isempty(find(Array(3,A{i-1}) >= Array(3,A{i}(j))))== 1
                rv = 0;
            end
         end   
    else
           if isempty(find(Array(3,A{i+1}) < Array(3,A{i}(j))+ d & Array(3,A{i+1}) >  Array(3,A{i}(j)) - d))== 1
            rp = 0;
           else
            rp = 1;
           end

           if isempty(find(Array(3,A{i-1}) < Array(3,A{i}(j))+ d & Array(3,A{i-1}) > Array(3,A{i}(j)) -d))== 1
                lp = 0;
           else
                lp = 1;
           end  


            if mean(Array(4, find(Array(3,A{i-1}) >= Array(3,A{i}(j))))) > mean(Array(4, find(Array(3,A{i}) >= Array(3,A{i}(j))))) 
                rv = 0;
            else
                rv = 1;
                if isempty(find(Array(3,A{i-1}) >= Array(3,A{i}(j))))== 1
                    rv = 0;
                end
            end

            if mean(Array(4, find(Array(3,A{i+1}) >= Array(3,A{i}(j))))) > mean(Array(4, find(Array(3,A{i}) >= Array(3,A{i}(j))))) 
                lv = 0;
            else
                lv = 1;
                if isempty(find(Array(3,A{i+1}) >= Array(3,A{i}(j))))== 1
                    lv = 0;
                end
            end 
    end
end
