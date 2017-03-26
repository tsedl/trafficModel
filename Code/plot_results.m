function []= plot_results(result_file, doSimulation)
close all; 
global TrackLength
    load(result_file);
    if(doSimulation == 1)  
        if Ramp_switch == 0 && lane_close_switch == 0
            writerObj = VideoWriter([pwd '/Visuals/Baseline/BaselineSimulation']); % Name it.
        elseif Ramp_switch == 1 && lane_close_switch == 0
            writerObj = VideoWriter([pwd '/Visuals/Onramp/OnrampSimulation']); % Name it.
        elseif Ramp_switch == 0 && lane_close_switch == 1
            writerObj = VideoWriter([pwd '/Visuals/ClosedLane/ClosedLaneSimulation']); % Name it.
        elseif Ramp_switch == 1 && lane_close_switch == 1
            writerObj = VideoWriter([pwd '/Visuals/OnrampLaneClosed/OnrampClosedLaneSimulation']); % Name it.
        end
        %writerObj = VideoWriter('out.avi'); % Name it.
        writerObj.FrameRate = 10; % How many frames per second.
        open(writerObj);
        % maybe move this to a function
        for k=1:size(OUTPUT,3)
            gscatter(OUTPUT(1,:,k),OUTPUT(2,:,k),OUTPUT(3,:,k),...
                    'mkbrg','xo.+*',6,'','Position (m)','Lane');
            set(gca,'ygrid','on','ytick',0:5,'tickdir','out')
            axis([0 TrackLength 0 5])
            legend('On Ramp','Initial Lane 1','Initial Lane 2', 'Initial Lane 3','Initial Lane 4')  
            legend('Location','bestoutside')
            legend('boxoff')
            title(sprintf('time: %f',k));
            % plot on-ramp
            hold on,plot([0 OnRampLength],[0 1]),hold off
            % Average Velocities for display
            vv1_avg = mean(vv(k,find(yy(k,:)==1)))*mph_rat; 
            vv2_avg = mean(vv(k,find(yy(k,:)==2)))*mph_rat; 
            vv3_avg = mean(vv(k,find(yy(k,:)==3)))*mph_rat; 
            vv4_avg = mean(vv(k,find(yy(k,:)==4)))*mph_rat; 
            VelLaneAvg = {['V4_{avg} = ', num2str(vv4_avg), ' mph'];...
                          ['V3_{avg} = ', num2str(vv3_avg), ' mph'];...
                          ['V2_{avg} = ', num2str(vv2_avg), ' mph'];...
                          ['V1_{avg} = ', num2str(vv1_avg), ' mph']};
            text(TrackLength+50,2,VelLaneAvg)
            % Make movie
            frame = getframe(gcf); % 'gcf' can handle if you zoom in to take a movie.
            writeVideo(writerObj, frame);
            pause(1e-20)
            shg
        end
        close(writerObj); % Saves the movie.
    end
%% Create plots for average system and individual cars

load('simulation_results_closed_lane.mat');
vv = vv*mph_rat; %convert m/s to mph
[m, ~] = size(vv);
for k = 1:m
    vvv = vv(k,:);
    v_system(k,:) = mean(vvv(vvv~=0));   % remove dummy cars from average 
    aaa = aa(k,:);
    a_system(k,:) = mean(aaa(aaa~=0));
end
a_system(1) = 0;
t_system = mean(tt,2);
V_system_total_average = mean(v_system)
A_system_total_average = mean(a_system)
%v_system = mean(vv,2);
%a_system = mean(aa,2);

figure
plot(tt,vv)
title('Velocity of indiviual cars vs time')
xlabel('Time (sec)'), ylabel('Velocity (mph)')

figure
plot(tt,aa)
title('Acceleration of indiviual cars vs time')
xlabel('Time (sec)'), ylabel('Acceleration (mph)')

%% System averages 
% System Velocity plot
figure(10)
plot(t_system,v_system);
title('Average velocity over time')
xlabel('Time (sec)'), ylabel('Velocity (mph)')
hold on, plot([0 t_system(end,1)], [62.5 62.5]),hold off
legend('Average System Velocity','Average Desired Velocity')
if Ramp_switch == 0 && lane_close_switch == 0
    saveas(gca,[pwd '/Visuals/Baseline/SysAvgVel_Baseline'],'jpeg');
    saveas(gca,[pwd '/Visuals/Baseline/SysAvgVel_Baseline'],'fig');
elseif Ramp_switch == 1 && lane_close_switch == 0
    saveas(gca,[pwd '/Visuals/Onramp/SysAvgVel_OnRamp'],'jpeg');
    saveas(gca,[pwd '/Visuals/Onramp/SysAvgVel_OnRamp'],'fig');
elseif Ramp_switch == 0 && lane_close_switch == 1
    saveas(gca,[pwd '/Visuals/ClosedLane/SysAvgVel_ClosedLane'],'jpeg');
    saveas(gca,[pwd '/Visuals/ClosedLane/SysAvgVel_ClosedLane'],'fig');
elseif Ramp_switch == 1 && lane_close_switch == 1
    saveas(gca,[pwd '/Visuals/OnrampLaneClosed/SysAvgVel_OnRampLaneClosed'],'jpeg');
    saveas(gca,[pwd '/Visuals/OnrampLaneClosed/SysAvgVel_OnRampLaneClosed'],'fig');
end

% System Acceleration plot
figure(20)
plot(t_system,a_system);
title('Average acceleration over time')
xlabel('Time (sec)'), ylabel('Acceleration (m/s^2)')
if Ramp_switch == 0 && lane_close_switch == 0
    saveas(gca,[pwd '/Visuals/Baseline/SysAvgAcc_Baseline'],'jpeg');
    saveas(gca,[pwd '/Visuals/Baseline/SysAvgAcc_Baseline'],'fig');
elseif Ramp_switch == 1 && lane_close_switch == 0
    saveas(gca,[pwd '/Visuals/Onramp/SysAvgAcc_OnRamp'],'jpeg');
    saveas(gca,[pwd '/Visuals/Onramp/SysAvgAcc_OnRamp'],'fig');
elseif Ramp_switch == 0 && lane_close_switch == 1
    saveas(gca,[pwd '/Visuals/ClosedLane/SysAvgAcc_ClosedLane'],'jpeg');
    saveas(gca,[pwd '/Visuals/ClosedLane/SysAvgAcc_ClosedLane'],'fig');
elseif Ramp_switch == 1 && lane_close_switch == 1
    saveas(gca,[pwd '/Visuals/OnrampLaneClosed/SysAvgAcc_OnRampLaneClosed'],'jpeg');
    saveas(gca,[pwd '/Visuals/OnrampLaneClosed/SysAvgAcc_OnRampLaneClosed'],'fig');
end

% System Velocity and Acceleration subplot
figure(15)
subplot(2,1,1)
plot(t_system,v_system);
title('Average velocity over time')
xlabel('Time (sec)'), ylabel('Velocity (mph)')
hold on, plot([0 tt(end,1)], [62.5 62.5]),hold off
legend('Average System Velocity','Average Desired Velocity')

% System Acceleration plot
subplot(2,1,2)
plot(t_system,a_system);
title('Average acceleration over time')
xlabel('Time (sec)'), ylabel('Acceleration (m/s^2)')
if Ramp_switch == 0 && lane_close_switch == 0
    saveas(gca,[pwd '/Visuals/Baseline/SysAvgVelAcc_Baseline'],'jpeg');
    saveas(gca,[pwd '/Visuals/Baseline/SysAvgVelAcc_Baseline'],'fig');
elseif Ramp_switch == 1 && lane_close_switch == 0
    saveas(gca,[pwd '/Visuals/Onramp/SysAvgVelAcc_OnRamp'],'jpeg');
    saveas(gca,[pwd '/Visuals/Onramp/SysAvgVelAcc_OnRamp'],'fig');
elseif Ramp_switch == 0 && lane_close_switch == 1
    saveas(gca,[pwd '/Visuals/ClosedLane/SysAvgVelAcc_ClosedLane'],'jpeg');
    saveas(gca,[pwd '/Visuals/ClosedLane/SysAvgVelAcc_ClosedLane'],'fig');
elseif Ramp_switch == 1 && lane_close_switch == 1
    saveas(gca,[pwd '/Visuals/OnrampLaneClosed/SysAvgVelAcc_OnRampLaneClosed'],'jpeg');
    saveas(gca,[pwd '/Visuals/OnrampLaneClosed/SysAvgVelAcc_OnRampLaneClosed'],'fig');
end

%% Randomly select cars to see plot for
r1 = randi([1 ceil(numCar/4)]);
r2 = randi([ceil(numCar/4) ceil(numCar/2)]);
r3 = randi([ceil(numCar/2) ceil(numCar*3/4)]);
r4 = randi([ceil(numCar*3/4) numCar]);
%% Individual Car Velocity/Velocity Subplot

figure(30)
subplot(2,2,1)
plot(tt(:,1),vv(:,r1))
title1 = ['Car ', num2str(r1), ' Velocity Over Time'];
title(title1)
xlabel('Time (sec)'), ylabel('Velocity (mph)')

subplot(2,2,2)
plot(tt(:,1),vv(:,r2))
title2 = ['Car ', num2str(r2), ' Velocity Over Time'];
title(title2)
xlabel('Time (sec)'), ylabel('Velocity (mph)')

subplot(2,2,3)
plot(tt(:,1),aa(:,r1))
title1 = ['Car ', num2str(r1), ' Acceleration Over Time'];
title(title1)
xlabel('Time (sec)'), ylabel('Acceleration (m/s^2)')

subplot(2,2,4)
plot(tt(:,1),aa(:,r2))
title1 = ['Car ', num2str(r2), ' Acceleration Over Time'];
title(title1)
xlabel('Time (sec)'), ylabel('Acceleration (m/s^2)')

if Ramp_switch == 0 && lane_close_switch == 0
    saveas(gca,[pwd '/Visuals/Baseline/CarVelAcc_1'],'jpeg');
    saveas(gca,[pwd '/Visuals/Baseline/CarVelAcc_1'],'fig');
elseif Ramp_switch == 1 && lane_close_switch == 0
    saveas(gca,[pwd '/Visuals/Onramp/CarVelAcc_1_OnRamp'],'jpeg');
    saveas(gca,[pwd '/Visuals/Onramp/CarVelAcc_1_OnRamp'],'fig');
elseif Ramp_switch == 0 && lane_close_switch == 1
    saveas(gca,[pwd '/Visuals/ClosedLane/CarVelAcc_1_ClosedLane'],'jpeg');
    saveas(gca,[pwd '/Visuals/ClosedLane/CarVelAcc_1_ClosedLane'],'fig');
elseif Ramp_switch == 1 && lane_close_switch == 1
    saveas(gca,[pwd '/Visuals/OnrampLaneClosed/CarVelAcc_1_OnRampLaneClosed'],'jpeg');
    saveas(gca,[pwd '/Visuals/OnrampLaneClosed/CarVelAcc_1_OnRampLaneClosed'],'fig');
end

%% Individual Car Velocity/Acceleration Subplot
figure(40)
subplot(2,2,1)
plot(tt(:,1),vv(:,r3))
title3 = ['Car ', num2str(r3), ' Velocity Over Time'];
title(title3)
xlabel('Time (sec)'), ylabel('Velocity (mph)')

subplot(2,2,2)
plot(tt(:,1),vv(:,r4))
title4 = ['Car ', num2str(r4), ' Velocity Over Time'];
title(title4)
xlabel('Time (sec)'), ylabel('Velocity (mph)')

subplot(2,2,3)
plot(tt(:,1),aa(:,r3))
title1 = ['Car ', num2str(r3), ' Acceleration Over Time'];
title(title1)
xlabel('Time (sec)'), ylabel('Acceleration (m/s^2)')

subplot(2,2,4)
plot(tt(:,1),aa(:,r4))
title1 = ['Car ', num2str(r4), ' Acceleration Over Time'];
title(title1)
xlabel('Time (sec)'), ylabel('Acceleration (m/s^2)')

if Ramp_switch == 0 && lane_close_switch == 0
    saveas(gca,[pwd '/Visuals/Baseline/CarVelAcc_2'],'jpeg');
    saveas(gca,[pwd '/Visuals/Baseline/CarVelAcc_2'],'fig');
elseif Ramp_switch == 1 && lane_close_switch == 0
    saveas(gca,[pwd '/Visuals/Onramp/CarVelAcc_2_OnRamp'],'jpeg');
    saveas(gca,[pwd '/Visuals/Onramp/CarVelAcc_2_OnRamp'],'fig');
elseif Ramp_switch == 0 && lane_close_switch == 1
    saveas(gca,[pwd '/Visuals/ClosedLane/CarVelAcc_2_ClosedLane'],'jpeg');
    saveas(gca,[pwd '/Visuals/ClosedLane/CarVelAcc_2_ClosedLane'],'fig');
elseif Ramp_switch == 1 && lane_close_switch == 1
    saveas(gca,[pwd '/Visuals/OnrampLaneClosed/CarVelAcc_2_OnRampLaneClosed'],'jpeg');
    saveas(gca,[pwd '/Visuals/OnrampLaneClosed/CarVelAcc_2_OnRampLaneClosed'],'fig');
end

% %% Individual Car Velocity Subplot
% for i = 4:4:numCar
% figure(50)
% subplot(2,2,1)
% plot(tt(:,1),vv(:,i-3))
% title1 = ['Car', num2str(i-3), 'Velocity Over Time'];
% title(title1)
% xlabel('Time (sec)'), ylabel('Velocity (mph)')
% 
% subplot(2,2,2)
% plot(tt(:,1),vv(:,i-2))
% title2 = ['Car', num2str(i-2), 'Velocity Over Time'];
% title(title2)
% xlabel('Time (sec)'), ylabel('Velocity (mph)')
% 
% subplot(2,2,3)
% plot(tt(:,1),vv(:,i-1))
% title3 = ['Car', num2str(i-1), 'Velocity Over Time'];
% title(title3)
% xlabel('Time (sec)'), ylabel('Velocity (mph)')
% 
% subplot(2,2,4)
% plot(tt(:,1),vv(:,i))
% title4 = ['Car', num2str(i), 'Velocity Over Time'];
% title(title4)
% xlabel('Time (sec)'), ylabel('Velocity (mph)')
% 
% shg
% pause(0.5)
% end
end
