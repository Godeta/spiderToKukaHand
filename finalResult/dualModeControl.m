% dualModeControl()
clear all;
close all;
clc;

% Mode selection
currentMode = 1; % Start in KUKA control mode

while true
    switch currentMode
        case 1 % KUKA Control Mode
            currentMode = kukaControlMode();

        case 2 % Arduino Serial Mode
            currentMode = arduinoSerialMode();

        otherwise
            disp('Invalid mode. Exiting.');
            break;
    end

    % Exit condition
    if currentMode == 0
        break;
    end
end

function nextMode = kukaControlMode()
    % Joystick configuration
    ID = 1; % Joystick ID (ensure the joystick is properly connected)
    joy = vrjoystick(ID);
    
    % Initial robot configuration in radians
    jPos = {0, pi / 180 * 30, 0, -pi / 180 * 60, 0, pi / 180 * 90, 0};
    
    % Start KUKA control server and move robot to initial configuration
    [tKuka, flag] = startDaDirectServo(jPos);
    if flag == false
        fprintf('Cannot connect to KUKA control server. Program terminated.\n');
        nextMode = 0;
        return;
    end
    
    % Inverse Kinematics (IK) solver parameters
    numberOfIterations = 10;
    lambda = 0.1;
    TefTool = eye(4);
    
    % Initial joint positions vector
    qin = zeros(7, 1);
    for i = 1:7
        qin(i) = jPos{i};
    end
    
    % Maximum velocities
    w = 10 * pi / 180; % Maximum angular velocity (rad/s)
    v = 0.15; % Maximum linear velocity (m/s)
    
    % Initialize control loop variables
    firstExecution = 0;
    pause(0.1);
    
    disp('Starting KUKA control mode...');
    
    % Control loop
    while true
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
            nextMode = 2;
            break;
        end
        
        % Exit if 'A' button is pressed
        if buttons(1) == 1
            disp('Control loop terminated by user.');
            nextMode = 0;
            break;
        end
    end
    
    % Close connection and turn off server
    net_turnOffServer(tKuka);
    fclose(tKuka);
    disp('KUKA control mode terminated.');
end

function nextMode = arduinoSerialMode()
    % Clear previous serial connections
%     delete(instrfind)
%     close all
%     
%     % Open serial connection
%     serialObj = serial("COM10","baudRate", 9600);
%     flushinput(serialObj);
%     fopen(serialObj);
%     
%     % Wait for user input or mode change
%     while true
%         % Read joystick to check for mode change
%         joy = vrjoystick(1);
%         [~, buttons, ~] = read(joy);
%         
%         % Prompt for input
%         val = input('Enter a text value (or press Ctrl+C to exit): ', 's');
%         
%         % Process value
%         if(str2double(val)<0)
%             val = num2str(abs(str2double(val)));
%         end
%         
%         % Send to Arduino
%         fprintf(serialObj,'%s\n',char(val));
%         
%         % Check for mode change (start button)
%         if buttons(8) == 1
%             disp('Switching back to KUKA mode');
%             nextMode = 1;
%             break;
%         end
    disp("mode 2 !!!");
    end
    
    % Close serial connection
    fclose(serialObj);
    disp('Arduino serial mode terminated.');
end