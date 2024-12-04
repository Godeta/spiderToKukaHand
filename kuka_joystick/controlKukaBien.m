clear all;
close all;
clc;
disp('Initializing robot control...');
 
% Ensure any previous connections are reset
instrreset;
 
% Joystick configuration
ID = 1; % Joystick ID (ensure the joystick is properly connected)
joy = vrjoystick(ID);
 
% Initial robot configuration in radians
jPos = {0, pi / 180 * 30, 0, -pi / 180 * 60, 0, pi / 180 * 90, 0};
 
% Start KUKA control server and move robot to initial configuration
[tKuka, flag] = startDaDirectServo(jPos);
if flag == false
    fprintf('Cannot connect to KUKA control server. Program terminated.\n');
    return;
end
 
% Inverse Kinematics (IK) solver parameters
numberOfIterations = 10; % Number of iterations for the solver
lambda = 0.1; % Regularization parameter for IK solver
TefTool = eye(4); % Tool transformation matrix
 
% Initial joint positions vector
qin = zeros(7, 1);
for i = 1:7
    qin(i) = jPos{i};
end
 
% Transformation matrix at initial configuration
[Tt, j] = directKinematics(qin, TefTool);
disp('Robot initialized successfully.');
 
% Define maximum velocities
w = 10 * pi / 180; % Maximum angular velocity (rad/s)
v = 0.15; % Maximum linear velocity (m/s)
 
% Initialize control loop variables
firstExecution = 0; % Flag for first iteration
pause(0.1);
 
disp('Starting control loop...');
% Control loop
while true
    % Read joystick input
    [axes, buttons, ~] = read(joy);
    analogPrecission = 1 / 20; % Deadzone threshold for joystick
 
    % Filter axes values to apply deadzone
    for i = 1:4
        if abs(axes(i)) < analogPrecission
            axes(i) = 0;
        end
    end
 
    % Calculate elapsed time since last iteration
    if firstExecution == 0
        firstExecution = 1;
        a = datevec(now);
        timeNow = a(6) + a(5) * 60 + a(4) * 60 * 60; % Current time in seconds
        dt = 0; % Elapsed time is zero at first iteration
        time0 = timeNow;
    else
        a = datevec(now);
        timeNow = a(6) + a(5) * 60 + a(4) * 60 * 60; % Current time in seconds
        dt = timeNow - time0; % Calculate elapsed time
        time0 = timeNow;
    end
 
    % Construct motion control command
    n = [axes(4); axes(3); 0]; % Translation control vector
    k = [0; 0; 1]; % Rotation axis (Z-axis)
    w_control = w * cross(n, k); % Angular velocity control
 
    % Calculate Z-axis value based on button inputs
    z_value = buttons(5) - buttons(6);
 
    % Update linear velocity control to include Z-axis
    v_control = v * [axes(2); axes(1); z_value]; % Linear velocity control
 
    % Update transformation matrix based on control inputs
    Tt = updateTransform(Tt, w_control, v_control, dt);
 
    % Update joint positions for IK solver
    for i = 1:7
        qin(i) = jPos{i};
    end
 
    % Solve IK and check joint limits
    qt = kukaDLSSolver(qin, Tt, TefTool, numberOfIterations, lambda);
    if size(qt) == [7, 1]
        errorFlag = false;
        % Define a dynamic threshold
        dynamicThreshold = pi * 1.0 / 180; % Increase or adjust as needed
 
        % Check for large deviations in joint values
        for i = 1:7
            deviation = abs(qt(i) - qin(i));
            if deviation > dynamicThreshold
                fprintf('Warning: Joint %d deviation %.4f exceeds threshold %.4f\n', ...
                        i, deviation, dynamicThreshold);
                errorFlag = true;
            end
        end
 
        % Handle errors
        if errorFlag
            disp('Error detected: Large joint deviation or joint limit violation.');
            for i = 1:7
                jPos{i} = qin(i); % Revert to the previous safe configuration
            end
        else
            for i = 1:7
                jPos{i} = qt(i);
                fprintf('Joint %d updated: %.4f\n', i, jPos{i});
            end
        end
    end
 
    % Send joint positions to robot
    val = sendJointsPositions(tKuka, jPos);
    if val == 0
        disp("echec");
    end
 
    % Break loop if 'A' button on joystick is pressed
    if buttons(1) == 1
        disp('Control loop terminated by user.');
        break;
    end
    % Break loop if 'start' button on joystick is pressed change mode
    if buttons(8) == 1
        disp('Change mode');
        break;
    end
end
 
% Close connection and turn off server
net_turnOffServer(tKuka);
fclose(tKuka);
disp('Robot control terminated.');