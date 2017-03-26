%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This program consists of 8 files, abm_main, acceleration,carClass,CarSort, %
%EOM, GetInput, PerimeterCheck, and plot_results functions/files.           %
%Everything is ran from main, and the major traffic factors can be modified % 
%here, but some need to be modified whithin their respective files.         % 
%Plots and simulation video are saved to the Visuals directory in the       %
%directory. User input is required to run different scenarios. The default  %
%simulation runs the baseline model. Thereafter user input is required      %
%%%%%%%%%%%%%% VALUES USED IN PAPER%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%   TimeSteps = 200;   % Seconds                                            %
%   close_lanes_after_t = 25;                                               %
%   TrackLength = 500;                                                      %
%   Ramp_switch = 0; Set value to 1 for onramp and value 2 for no onramp    %
%   lane_close_switch = 0; Set value to 1 to close lanes and 2 to keep open %
%   numDumCar = 50;    %On-ramp cars                                        %
%   CarSpace = 25; Set to 50 keeping same TrackLength to double initial cars%                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc
[lane_close_switch, Ramp_switch, TrackLength, TimeSteps, close_lanes_after_t,numDumCar,CarSpace] = GetInput
for run = 1:1
global tau taus gamma lagD TrackLength TEST OnRampLength
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize everything
% Constants
tau = 3;    taus = 1.5;   gamma = 1.5;  lagD = 2;
numLanes = 4;  
OnRampLength = 50;
x_i = [1:CarSpace:TrackLength];           % Initial x location -- meters
mph_rat = 60*60/1609.34;            % sec/hr * mile/meter
DV = [55 60 65 70]/mph_rat; % mph -> m/s -- Desired Velocity
v_i = [55 60 65 70]/mph_rat;        % mph -> m/s -- Initial Velocity
SD = [16.764 18.288 19.812 21.336]; % meters -- Safe Distance
rp = 1;     lp = 1;     t_i = 0;    a_i = 0;
z_i = 0;

%Set = nonzero for varying desired velocities
RV = 2; %The value increase the variance

%% Initialize Cars 
numCar=1;
car=[];
for i=1:length(x_i)
    for j=1:numLanes
        %if(rand < 0.20) % increase for more initial cars
            car = [car, carClass];
            car(numCar).init(numCar,x_i(i),j,j,SD(j),DV(j),lp,rp,v_i(j),RV,t_i,a_i,z_i);
            numCar = numCar + 1;
        %end
    end
end
numCar = length(car);


%% Initialize Dummy Cars for the onramp
DummyCars = numCar+1;
onx = 0;
ony = 0;
onSd = 15;
onVel = 55/mph_rat;
onV = 0/mph_rat; % Car velocity prior to entering onramp
rampV = 45/mph_rat;% Car velocity on onramp
for i = 1:numDumCar
    car = [car, carClass];
    car(DummyCars).init(DummyCars,onx,ony,ony,onSd,onVel,lp,rp,0,RV,t_i,a_i,z_i);
    car(DummyCars).v = abs(car(DummyCars).v);
    DummyCars = DummyCars + 1;
end
numDumCar = DummyCars-numCar;
DummyCars = numCar+1;

% Store Initial Parameters
tt = [car(:).t];
yy = [car(:).y];
vv = [car(:).v];
aa = [car(:).a];

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
geton = 0;
initgetonV = 0;
h = waitbar(1/TimeSteps,'Running simulation...');
for time = 1:TimeSteps

% Update cars on the on ramp
if Ramp_switch == 1
    if geton < numDumCar-1
        if car(DummyCars+geton).y < 1
            initgetonV = initgetonV + 1;
        if initgetonV == 1
            car(DummyCars+geton).v = rampV;
        end
            car(DummyCars+geton).kinetics(50,10,1);
            for tstep = DummyCars+geton+1:numDumCar+numCar-1
                initgetonV = 0;
                car(tstep).sett(time-1);
            end
        end
        if car(DummyCars+geton).y > 0.999
        geton = geton + 1;
        end
    end
end      
% Grabs desired properties from cars
LocArray = [car(:).idx; car(:).y;  car(:).x ; car(:).v];

% Sorted paremeters by x value
[L, A] = CarSort(LocArray);

%we begin by calculating space between cars 
for i = 1:4
    if L(i)~=0;
        Dx{i}(1)= TrackLength + (car(A{i}(end)).x - car(A{i}(1)).x);
        Dx{i}(2:length(A{i})) = LocArray(3,A{i}(1:end-1))- LocArray(3,A{i}(2:end));
        V{i}(1)= LocArray(4,A{i}(end)) - LocArray(4,A{i}(1));
        V{i}(2:length(A{i})) = LocArray(4,A{i}(1:end-1))- LocArray(4,A{i}(2:end));
    end
end

%use space between cars and velocity diference to calc position change
for i = 1:4
    %location update function
    for j=1:L(i)
        if L(i)~=0;
            Space = Dx{i}(j);
            dVel = V{i}(j);
            if Space < 0;
                Space  = TrackLength + Space;
            end
            if lane_close_switch == 1
                y0 = car(A{i}(j)).y;
                if(time > close_lanes_after_t && (y0 == 3 || y0 == 4)) % <<<<<<<<<<<<<<< choose which lanes to stall
                    continue;
                end
            end
            % Calculate Distance, Velocity and Acceleration
            car(A{i}(j)).kinetics(Space,dVel,0);
        end
    end
end

LocArray = [car(:).idx; car(:).y;  car(:).x ; car(:).v];

% conduct perimeter check and change lanes if wanted and possible 
for i = 1:4
    if L(i) ~= 0;
        for j = 1:L(i)
            [lp, rp, lv, rv] = PerimeterCheck(LocArray,A,i,j);
            car(A{i}(j)).updateP(lp,rp);
            if(time > close_lanes_after_t)
                car(A{i}(j)).updateLane1(lv,rv);
            else
                car(A{i}(j)).updateLane(lv,rv);
            end
            LocArray(2,A{i}(j)) = car(A{i}(j)).y; 
        end
    end
end

[~, index] = sort([car(:).x] , 'descend');

%Re-assign indexes based on position
for i = 1:length(index)
    car(LocArray(1,index(i))).setIdx(index(i));
end

% store the output and plot later
OUTPUT(1,:,time) = [car(:).x ];
OUTPUT(2,:,time) = [car(:).y ];
OUTPUT(3,:,time) = [car(:).group ];
    
% Store car parameters
tt = [tt; car(:).t];
yy = [yy; car(:).y];
vv = [vv; car(:).v];
aa = [aa; car(:).a];

clearvars A Lane1 Lane2 Lane3 Lane4 Space LocArray1

waitbar(time/TimeSteps);

end
close(h);

%% Use for averaging multiple runs and comment out last three lines of code
% vv = vv*mph_rat; %convert m/s to mph
% [m, ~] = size(vv);
% for k = 1:m
%     vvv = vv(k,:);
%     v_system(k,:) = mean(vvv(vvv~=0));   % remove dummy cars from average 
%     aaa = aa(k,:);
%     a_system(k,:) = mean(aaa(aaa~=0));
%     if isnan(a_system(k,:))
%         a_system(k,:) = 0;
%     end
% end
% 
% 
% t_system = mean(tt,2);
% V_system_total_average(run) = mean(v_system)
% A_system_total_average(run) = mean(a_system)
% 
% run
% 
% clearvars car tt yy vv aa 
end
% run_V_avg = mean(V_system_total_average)
% run_A_avg = mean(A_system_total_average)


save('simulation_results_closed_lane.mat');
 %% do the plots 
 doSimulation = 1; % change to 0 to skip the simulationc
 plot_results('simulation_results_closed_lane.mat',doSimulation);
