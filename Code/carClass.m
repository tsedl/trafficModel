%% Basic Car Class with many properties
classdef carClass<handle % this was necessary in order to update props
    properties (SetAccess=public,GetAccess=public)
        idx;
        x;
        y;
        lane;
        group;
        Sd;
        Va;
        v;
        lp;
        rp;
        a;
        RV;
        t;
        z;
    end
    methods(Access = public)
        function obj=init(obj,idx,x,y,lane,Sd,Va,lp,rp,v,RV,t,a,z)
            obj.idx = idx;
            obj.x = x;
            obj.y = y;
            obj.lane = lane;
            obj.group = lane;
            obj.Sd = Sd;
            obj.Va = Va;
            obj.lp = lp;
            obj.rp = rp;
            obj.a = a;
            if v > 0
                obj.v = v + randn*RV;
            else
                obj.v = 0;
            end
            obj.t = t;
            obj.z = z;
        end
        function obj = setLane(obj,newLane)
           obj.lane = newLane;
        end
        
        function obj = setIdx(obj,I)
            obj.idx = I;
        end
        function obj = laneRight(obj)
            obj.y = obj.y-1;
            obj.setLaneParams(obj.y);
        end
        
        function obj = laneLeft(obj)
            obj.y = obj.y+1;
            obj.setLaneParams(obj.y);
        end
        function obj = setLaneParams(obj,y)
            if y == 1
                obj.Va = 24.5;
                obj.Sd = 16.764;
            elseif y == 2
                obj.Va = 26.8; 
                obj.Sd = 18.288;
            elseif y == 3
                obj.Va = 29;
                obj.Sd = 19.812;
            elseif y == 4
                obj.Va = 31.3;
                obj.Sd = 21.336;
            end
        end
        function obj = sett(obj,t)
            obj.t = t + 1;
        end
        function obj = updateP(obj,lp,rp)
            obj.lp = lp;
            obj.rp = rp;   
        end
        %%%%%%%%%%%%%%% KINETICS %%%%%%%%%%%%%%%%%%%%       
        function obj = kinetics(obj,Space,dVel,onramp)
            global TrackLength OnRampLength
            if onramp == 0
                x0 = obj.x;    
            elseif onramp == 1
                x0 = obj.z;
            end                
            v0 = obj.v;
            IC = [x0 v0];            
            t0 = obj.t;    obj.sett(t0);  tf = obj.t;
            tspan = t0:tf;
            [~, X] = ode15s(@(t,x)EOM(t,x,Space,obj.Va,obj.Sd,dVel),tspan,IC);          
            if onramp == 0                 
                obj.x = mod(X(end,1),TrackLength);
            elseif onramp == 1
                zmax = sqrt(OnRampLength^2+1);
                obj.z = X(end,1);
                if obj.z < zmax
                    obj.x = obj.z*cos(atan(1/OnRampLength));
                    obj.y = obj.z*sin(atan(1/OnRampLength));
                else
                    obj.x = OnRampLength + (obj.z - zmax);
                    obj.y = 1;
                    obj.lane = 1;
                end
            end
            obj.v = X(end,2);
            % Calculate Acceleration    
            obj.a = acceleration(obj.v, obj.Va, Space, dVel, obj.Sd );
        end      
% AC modifications 
        function obj = updateLane1(obj, lv, rv)
            rand_val = rand;
            if rand_val < 4/8*0.3 && obj.lp == 0 && lv == 0;
                if obj.y > 1   % <<<< change to remaining open lanes
                    obj.laneRight;
                elseif obj.y < 2
                    obj.laneLeft;
                end 
            elseif rand_val > (1 - 4/8*0.3) && obj.rp == 0 && rv == 0;
                if obj.y < 5 && obj.y > 2  % <<<< change to remaining open lanes
                    obj.laneRight;
                elseif obj.y < 2
                    obj.laneLeft;
                end                
            else
            end
        end
        function obj = updateLane(obj, lv, rv)
            rand_val = rand;
            if rand_val < 1/8 && obj.lp == 0 && lv == 0;
                if obj.y < 4   % <<<< change to remaining open lanes
                    obj.laneLeft;
                end 
            elseif  rand_val > 7/8 && obj.rp == 0 && rv == 0;
                if obj.y > 1   % <<<< change to remaining open lanes
                    obj.laneRight;
                end                
            else
            end
        end
    end
end