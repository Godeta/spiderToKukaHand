close all;

% Initialize joystick and figure
joy = vrjoystick(1);
h_fig = figure('Name', 'Xbox Controller Visualization', 'KeyPressFcn', @(src, event) stopOnJPress(src, event));
t = timer;
t.Period = 0.04;  % Update every 0.04 seconds
t.ExecutionMode = 'fixedRate';
t.TimerFcn = @(~,~) updatePlot(t, joy);

% Store figure handle in timer UserData
t.UserData = h_fig;

% Start the timer
start(t);

% Function to fetch and plot data
function updatePlot(t, joy)
    % Check if the timer and figure handle are still valid
    if ~isvalid(t) || ~isvalid(t.UserData)
        return;  % Exit if either the timer or figure is invalid
    end
    
    % Retrieve figure handle from timer UserData
    h_fig = t.UserData;
    
    % Get joystick data
    [axes, buttons, ~] = read(joy);
    process_and_plot(h_fig, axes, buttons);
    
end

% Function to process joystick inputs and update the visualization
function y = process_and_plot(h_fig, axes, buttons)
    % Initialize persistent variables for joystick positions and circles
    persistent prev_x1 prev_y1 prev_x2 prev_y2 h_circle1 h_circle2;
    
    % Initialize position variables if empty
    if isempty(prev_x1)
        prev_x1 = 0;
        prev_y1 = 0;
        prev_x2 = 0;
        prev_y2 = 0;
    end

    % Initialize circle handles if empty or invalid
    if isempty(h_circle1) || isempty(h_circle2) || ~isvalid(h_fig)
        clf(h_fig);  % Clear the figure
        hold on;
        h_circle1 = plot(prev_x1, prev_y1, 'o', 'MarkerSize', 20, 'MarkerFaceColor', 'w');
        h_circle2 = plot(prev_x2, prev_y2, 'o', 'MarkerSize', 20, 'MarkerFaceColor', 'w');
        
        % Set up the plot
        xlim([-1.2 1.2]);
        ylim([-1.2 1.2]);
        grid on;
        title('Xbox Controller Circles');
        axis square;
        hold off;
    end

    % Process joystick inputs with deadzone
    deadzone = 0.1;
    x1 = applyDeadzone(axes(1), deadzone);
    y1 = applyDeadzone(axes(2), deadzone);
    x2 = applyDeadzone(axes(4), deadzone);
    y2 = applyDeadzone(axes(5), deadzone);

    % Scale and update positions
    scale = 0.1;
    x1 = bound(prev_x1 + x1 * scale);
    y1 = bound(prev_y1 - y1 * scale);
    x2 = bound(prev_x2 + x2 * scale);
    y2 = bound(prev_y2 - y2 * scale);

    % Store current positions for next iteration
    prev_x1 = x1;
    prev_y1 = y1;
    prev_x2 = x2;
    prev_y2 = y2;

    % Update circle positions and colors
    if isvalid(h_circle1) && isvalid(h_circle2)
        set(h_circle1, 'XData', x1, 'YData', y1);
        set(h_circle2, 'XData', x2, 'YData', y2);
    end

    % Process button inputs for colors
    color1 = determineColor(buttons(1:4));
    color2 = determineColor(buttons(5:8));

    % Update colors based on button inputs
    colors = {'w', 'g', 'r', 'b', 'y'};
    if isvalid(h_circle1)
        set(h_circle1, 'MarkerFaceColor', colors{color1 + 1});
    end
    if isvalid(h_circle2)
        set(h_circle2, 'MarkerFaceColor', colors{color2 + 1});
    end

    drawnow limitrate;
    y = x1 * 10; % Placeholder for Arduino communication
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
function stopOnJPress(~, event)
    if strcmp(event.Key, 'j')
        % Stop and delete the timer
        stop(timerfindall);
        delete(timerfindall);
        
        % Close all figures and clear persistent variables
        close all;
        clear persistent;
    end
end
