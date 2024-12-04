close all;
%% Example joystick PTP
 
warning('off');
ip='172.31.1.147'; % The IP of the controller
 
t_Kuka=net_establishConnection( ip );% start a connection with the server
 
if ~exist('t_Kuka','var') || isempty(t_Kuka) || strcmp(t_Kuka.Status,'closed')
  warning('Connection could not be establised, script aborted');
  return;
else   
    close all;
 
    % Initialize joystick 
    joy = vrjoystick(1);
    % Initialize figure and timer
    h_fig = figure('Name', 'Xbox Controller Visualization', 'KeyPressFcn', @(src, event) stopOnJPress(src, event, t_Kuka));
    t = timer;
    t.Period = 0.02;  % Update every 0.04 seconds
    t.ExecutionMode = 'fixedRate';
    t.TimerFcn = @(~,~) updatePlot(t, t_Kuka, joy);
    % Store figure handle in timer UserData
    t.UserData = h_fig;
    % Start the timer
    start(t);
  %% move to initial position
      pinit={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % initial confuguration
      relVel=0.15; % relative velocity
      movePTPJointSpace( t_Kuka , pinit, relVel); % point to point motion in joint space
 
    %% Get position oientation of end effector
      disp('Cartesian position')
      Pos=getEEFPos( t_Kuka )
      relVel=50; % velocity of the end effector, mm/sec
      disp=50;
 
      %% Move the endeffector to a destination frame, 
       %Pos={400,0,580,-pi,0,-pi}; % first configuration % the coordinates are: x=400mm, y=0mm, z=580 mm. the rotation angles are: alpha=-180 degrees, beta=0 degrees, gama=-180 degrees
       %movePTPLineEEF( t_Kuka , Pos, relVel)
end
warning('on');
 

% Function to fetch and plot data
function updatePlot(t, t_Kuka ,joy)
    % Check if the timer and figure handle are still valid
    if ~isvalid(t) || ~isvalid(t.UserData)
        return;  % Exit if either the timer or figure is invalid
    end
    % Retrieve figure handle from timer UserData
    h_fig = t.UserData;
    % Get joystick data
    [axes, buttons, ~] = read(joy);
    [x,y,z, x2, y2, z2] = process_and_plot_3D(h_fig, axes, buttons);
    TEST = 100
% Mise à jour indépendante des translations et rotations
targetPos = {
    400 + x * 100,  % Translation X
    0 + y * 100,    % Translation Y
    580 + z * 500,  % Translation Z
    -pi + TEST * (pi/180) * x2, % Rotation X
    0 + TEST * (pi/180) * y2,   % Rotation Y
    -pi + TEST * (pi/180) * z2  % Rotation Z
};
    % new target position
    relVel = 150; % velocity of the end effector, jmm/sec movePTPJointSpace
    movePTPLineEEF(t_Kuka, targetPos, relVel);
end
 
% Function to process joystick inputs and update the 3D visualization
function [x,y,z, x2, y2, z2] = process_and_plot_3D(h_fig, axes, buttons)
    % Initialize persistent variables for joystick positions and marker
    persistent prev_x prev_y prev_z prev_x2 prev_y2 prev_z2 h_marker;
    % Initialize position variables if empty
    if isempty(prev_x)
        prev_x = 0;
        prev_y = 0;
        prev_z = 0;
        prev_x2 = 0;
        prev_y2 = 0;
        prev_z2 = 0;
    end
 
    % Initialize 3D marker if empty or invalid
    if isempty(h_marker) || ~isvalid(h_fig)
        clf(h_fig);  % Clear the figure
        hold on;
        h_marker = plot3(prev_x, prev_y, prev_z, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'w');
        % Set up the 3D plot
        xlim([-1.2 1.2]);
        ylim([-1.2 1.2]);
        zlim([-1.2 1.2]);
        grid on;
        title('Xbox Controller 3D Position');
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        view(45, 30); % Set the view angle for better 3D perception
        axis square;
        hold off;
    end
 
    % Process joystick inputs with deadzone
    deadzone = 0.1;
    x = applyDeadzone(axes(1), deadzone);
    y = applyDeadzone(axes(2), deadzone);
    x2 = applyDeadzone(axes(4), deadzone);
    y2 = applyDeadzone(axes(5), deadzone);
    % Adjust z using LB and RB buttons instead of axes
    scale = 0.1;
    if buttons(5)  % LB button pressed
        z = bound(prev_z - scale);
    elseif buttons(6)  % RB button pressed
        z = bound(prev_z + scale);
    else
        z = prev_z;  % Keep the same z position if neither is pressed
    end
    if buttons(7)  % LB button pressed
        z2 = bound(prev_z2 - scale);
    elseif buttons(8)  % RB button pressed
        z2 = bound(prev_z2 + scale);
    else
        z2 = prev_z2;  % Keep the same z position if neither is pressed
    end
 
    % Scale and update positions
    x = bound(prev_x + x * scale);
    y = bound(prev_y - y * scale);
    x2 = bound(prev_x2 + x2 * scale);
    y2 = bound(prev_y2 - y2 * scale);
 
    % Store current positions for next iteration
    prev_x = x;
    prev_y = y;
    prev_z = z;
    prev_x2 = x2;
    prev_y2 = y2;
    prev_z2 = z2;
 
    % Update marker position
    if isvalid(h_marker)
        set(h_marker, 'XData', x, 'YData', y, 'ZData', z);
    end
 
    % Process button inputs for marker color
    color = determineColor(buttons);
    colors = {'w', 'g', 'r', 'b', 'y'};
    if isvalid(h_marker)
        set(h_marker, 'MarkerFaceColor', colors{color + 1});
    end
 
    drawnow limitrate;
    y = x * 10; % Placeholder for Arduino communication
end
 
% Helper function to apply deadzone
function out = applyDeadzone(in, deadzone)
    if abs(in) < deadzone
        out = 0;
    else
        out = in;
    end
end
 
% Helper function to keep values within bounds
function out = bound(in)
    out = min(max(in, -1), 1);
end
 
% Helper function to determine color based on buttons
function color = determineColor(buttons)
    if buttons(1)
        color = 1;  % Green
    elseif buttons(2)
        color = 2;  % Red
    elseif buttons(3)
        color = 3;  % Blue
    elseif buttons(4)
        color = 4;  % Yellow
    else
        color = 0;  % Default white
    end
end
 
% Function to stop the timer and close figure on "j" key press
function stopOnJPress(~, event, t_Kuka)
    if strcmp(event.Key, 'j')
        % Stop and delete the timer
        stop(timerfindall);
        delete(timerfindall);
      %% turn off the server
       net_turnOffServer( t_Kuka );
       fclose(t_Kuka);
 
        % Close all figures and clear persistent variables
        close all;
        clear persistent;
    end
end