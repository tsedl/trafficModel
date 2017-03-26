function [ lane_close_switch, Ramp_switch,TrackLength,TimeSteps,close_lanes_after_t,numDumCar,CarSpace  ] = GetInput(  )
%This funciton is used to gather user input for system configuration
button = questdlg('Use default simulation settings: baseline','Default','Yes','No','No');
switch button
    case 'Yes'
       default = 1;
    case 'No'
       default = 0;
    case ''
        return
end  
% DEFAULT SETTINGS BELOW
if default == 1
    TimeSteps = 200;   % Seconds
    close_lanes_after_t = 1000000; %needs to be large to ignore logic to close lanes then t>t_close
    TrackLength = 500;
    Ramp_switch = 0; %Set = 1 for onramp and set=2 for no onramp
    lane_close_switch = 0;
    numDumCar = 1;
    CarSpace = 25;

% Prompt user for input below    
elseif default == 0 
    input1 = inputdlg('Set the simulation time in seconds');
    TimeSteps = str2double(input1);   % Seconds
    %TimeSteps = 200;
    
    input3 = inputdlg('Enter the track length in meters');
    TrackLength = str2double(input3);   % m  
    %TrackLength = 500;
    
    input5 = inputdlg('Enter distance in between cars in meters');
    CarSpace = str2double(input5);   % m  
    
    % CLOSE LANES
    button1 = questdlg('Close Lanes','Close Lanes','Yes','No','Yes');
    switch button1
        case 'Yes'
           lane_close_switch = 1;
        case 'No'
           lane_close_switch = 0;
        case ''
            return    
    end
    
    if lane_close_switch == 1
        %close_lanes_after_t = 25;
        input2 = inputdlg('Enter how many seconds into simulation to close lanes');
        close_lanes_after_t = str2double(input2);   % Seconds
    else
        close_lanes_after_t = 10000000;
    end
    % ON RAMP
    button2 = questdlg('On Ramp','On Ramp','Yes','No','Yes');
    switch button2
        case 'Yes'
           Ramp_switch = 1;
        case 'No'
           Ramp_switch = 0;
        case ''
            return 
    end
    
    if Ramp_switch ==1 
  %      numDumCar =50;
        input4 = inputdlg('Enter total number of on ramp cars');
        numDumCar = str2double(input4); 
    else
        numDumCar = 1;
    end

end
