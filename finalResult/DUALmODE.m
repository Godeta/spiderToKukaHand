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
 
% Mode selection
currentMode = 1; % Start in KUKA control mode
 
while true
    switch currentMode
        case 1 % KUKA Control Mode
            % Read joystick input
            [axes, buttons, ~] = read(joy);
            analogPrecission = 1 / 20;
            % Filter axes values
            for i = 1:4
                if abs(axes(i)) < analogPrecission
                    axes(i) = 0;
                end
            end
            % Time calculation
            if firstExecution == 0
                firstExecution = 1;
                a = datevec(now);
                timeNow = a(6) + a(5) * 60 + a(4) * 60 * 60;
                dt = 0;
                time0 = timeNow;
            else
                a = datevec(now);
                timeNow = a(6) + a(5) * 60 + a(4) * 60 * 60;
                dt = timeNow - time0;
                time0 = timeNow;
            end
            % Motion control command
            n = [axes(4); axes(3); 0];
            k = [0; 0; 1];
            w_control = w * cross(n, k);
            % Z-axis value based on button inputs
            z_value = buttons(5) - buttons(6);
            v_control = v * [axes(2); axes(1); z_value];
            % Update transformation matrix
            Tt = updateTransform(Tt, w_control, v_control, dt);
            % Update joint positions
            for i = 1:7
                qin(i) = jPos{i};
            end
            % Solve IK and check joint limits
            qt = kukaDLSSolver(qin, Tt, TefTool, numberOfIterations, lambda);
            if size(qt) == [7, 1]
                errorFlag = false;
                dynamicThreshold = pi * 1.0 / 180;
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
                        jPos{i} = qin(i);
                    end
                else
                    for i = 1:7
                        jPos{i} = qt(i);
                    end
                end
            end
            % Send joint positions to robot
            val = sendJointsPositions(tKuka, jPos);
            if val == 0
                disp("echec");
            end
            % Break loop and switch to Arduino mode if 'start' button is pressed
            if buttons(8) == 1
                disp('Switching to Arduino mode');
                currentMode = 2;
                % Close connection and turn off server
                net_turnOffServer(tKuka);
                fclose(tKuka);
                disp('KUKA control mode terminated.');
                continue;
            end
            % Exit if 'A' button is pressed
            if buttons(1) == 1
                disp('Control loop terminated by user.');
                currentMode = 0;
                break;
            end
        
        
    
        case 2 % Arduino Serial Mode
            
            delete(instrfind)
        %     close all
%             disp('inside');
            for i = 1:2
                % Open serial connection
                serialObj = serial("COM4","baudRate", 9600);
                flushinput(serialObj);
                fopen(serialObj);
                % Read joystick 
                joy = vrjoystick(1);
                val = ''
                while true
                    [~, buttons, ~] = read(joy);

                    % Prompt for input
%                     val = input('Enter a text value (or press Ctrl+C to exit): ', 's');

                    if buttons(2) == 1
                            val = '1'
                    end
                    if buttons(3) == 1
                            val = '2'
                    end
                    if buttons(4) == 1
                            val = '3'
                    end
%                     disp('inside 2');

                    % Send to Arduino
                    fprintf(serialObj,'%s\n',val);

                    % Check for mode change (start button)
                    if buttons(7) == 1
%                         quit and restart the program
                        % Close any open connections and cleanup
                        instrreset; % Reset any open instrument objects
                        clearvars; % Clear all variables from the workspace
                        close all; % Close all figure windows
                        clc; % Clear the command window

                        % Restart the program
                        run('DUALmODE.m'); % Re-run the current script
                        return; % Ensure the current instance terminates after restart
                    end
                disp("mode 2 !!!");
                end
            end
 
        otherwise
            disp('Invalid mode. Exiting.');
            break;
    end
 
    % Exit condition
    if currentMode == 0
        break;
    end
end
 
 
    % Close serial connection
%     fclose(serialObj);
%     disp('Arduino serial mode terminated.');
% end