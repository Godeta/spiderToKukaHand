clear;
clc;
close all;

%Constante
l1 = 2.5; % Longueur du premier lien
l2 = 16.5; % Longueur du deuxième lien

pas_temps = 0.1 ;
t_total = 0:pas_temps:10;


% Lancement de la simulation
SimOut = sim("simulation.slx",t_total);
[l,c] = size(SimOut.JOINT.signals.values);

% Récupération de la trajectoire
X_traj = SimOut.TRAJ(:,1);
Y_traj = zeros(size(SimOut.TRAJ));
Z_traj = SimOut.TRAJ(:,2);

% Boucle pour l'animation

X_origine_patte1 = 8;
Y_origine_patte1 = 4.4;

X_origine_patte2 = 8;
Y_origine_patte2 = -4.4;

X_origine_patte3 = 0;
Y_origine_patte3 = 4.4;

X_origine_patte4 = 0;
Y_origine_patte4 = -4.4;

X_origine_patte5 = -8;
Y_origine_patte5 = 4.4;

X_origine_patte6 = -8;
Y_origine_patte6 = -4.4;

for i = 1:l
    %Patte 1
    patte1_x1 = SimOut.JOINT.signals.values(i,1) + X_origine_patte1;
    patte1_y1 = SimOut.JOINT.signals.values(i,2) + Y_origine_patte1;
    patte1_z1 = SimOut.JOINT.signals.values(i,3);
    patte1_x2 = SimOut.JOINT.signals.values(i,4) + X_origine_patte1;
    patte1_y2 = SimOut.JOINT.signals.values(i,5) + Y_origine_patte1;
    patte1_z2 = SimOut.JOINT.signals.values(i,6);
    
    %Patte 2
    patte2_x1 = SimOut.JOINT.signals.values(i,7) + X_origine_patte2;
    patte2_y1 = SimOut.JOINT.signals.values(i,8) + Y_origine_patte2;
    patte2_z1 = SimOut.JOINT.signals.values(i,9);
    patte2_x2 = SimOut.JOINT.signals.values(i,10) + X_origine_patte2;
    patte2_y2 = SimOut.JOINT.signals.values(i,11) + Y_origine_patte2;
    patte2_z2 = SimOut.JOINT.signals.values(i,12);
    
    %Patte 3
    patte3_x1 = SimOut.JOINT.signals.values(i,13) + X_origine_patte3;
    patte3_y1 = SimOut.JOINT.signals.values(i,14) + Y_origine_patte3;
    patte3_z1 = SimOut.JOINT.signals.values(i,15);
    patte3_x2 = SimOut.JOINT.signals.values(i,16) + X_origine_patte3;
    patte3_y2 = SimOut.JOINT.signals.values(i,17) + Y_origine_patte3;
    patte3_z2 = SimOut.JOINT.signals.values(i,18);
    
    %Patte 4
    patte4_x1 = SimOut.JOINT.signals.values(i,19) + X_origine_patte4;
    patte4_y1 = SimOut.JOINT.signals.values(i,20) + Y_origine_patte4;
    patte4_z1 = SimOut.JOINT.signals.values(i,21);
    patte4_x2 = SimOut.JOINT.signals.values(i,22) + X_origine_patte4;
    patte4_y2 = SimOut.JOINT.signals.values(i,23) + Y_origine_patte4;
    patte4_z2 = SimOut.JOINT.signals.values(i,24);
    
    %Patte 5
    patte5_x1 = SimOut.JOINT.signals.values(i,25) + X_origine_patte5;
    patte5_y1 = SimOut.JOINT.signals.values(i,26) + Y_origine_patte5;
    patte5_z1 = SimOut.JOINT.signals.values(i,27);
    patte5_x2 = SimOut.JOINT.signals.values(i,28) + X_origine_patte5;
    patte5_y2 = SimOut.JOINT.signals.values(i,29) + Y_origine_patte5;
    patte5_z2 = SimOut.JOINT.signals.values(i,30);
    
    %Patte 6
    patte6_x1 = SimOut.JOINT.signals.values(i,31) + X_origine_patte6;
    patte6_y1 = SimOut.JOINT.signals.values(i,32) + Y_origine_patte6;
    patte6_z1 = SimOut.JOINT.signals.values(i,33);
    patte6_x2 = SimOut.JOINT.signals.values(i,34) + X_origine_patte6;
    patte6_y2 = SimOut.JOINT.signals.values(i,35) + Y_origine_patte6;
    patte6_z2 = SimOut.JOINT.signals.values(i,36);

    xtrace(i) = patte1_x2;
    ytrace(i) = patte1_y2;
    ztrace(i) = patte1_z2;
        
    clf; % Effacer la figure précédente
    %Corp robot
    plot3([X_origine_patte1, X_origine_patte2], [Y_origine_patte1, Y_origine_patte2],[0, 0], 'g', 'LineWidth', 2);
    hold on;
    plot3([X_origine_patte2, X_origine_patte4], [Y_origine_patte2, Y_origine_patte4],[0, 0], 'g', 'LineWidth', 2);
    plot3([X_origine_patte4, X_origine_patte6], [Y_origine_patte4, Y_origine_patte6],[0, 0], 'g', 'LineWidth', 2);
    plot3([X_origine_patte6, X_origine_patte5], [Y_origine_patte6, Y_origine_patte5],[0, 0], 'g', 'LineWidth', 2);
    plot3([X_origine_patte5, X_origine_patte3], [Y_origine_patte5, Y_origine_patte3],[0, 0], 'g', 'LineWidth', 2);
    plot3([X_origine_patte3, X_origine_patte1], [Y_origine_patte3, Y_origine_patte1],[0, 0], 'g', 'LineWidth', 2);
    
    
    % patte 1
    plot3([X_origine_patte1, patte1_x1], [Y_origine_patte1, patte1_y1],[0, patte1_z1], 'b', 'LineWidth', 2); % Lien 1
    plot3([patte1_x1, patte1_x2], [patte1_y1, patte1_y2],[patte1_z1, patte1_z2], 'r', 'LineWidth', 2); % Lien 2
    
    % patte 2
    plot3([X_origine_patte2, patte2_x1], [Y_origine_patte2, patte2_y1],[0, patte2_z1], 'b', 'LineWidth', 2); % Lien 1
    plot3([patte2_x1, patte2_x2], [patte2_y1, patte2_y2],[patte2_z1, patte2_z2], 'r', 'LineWidth', 2); % Lien 2
    
    % patte 3
    plot3([X_origine_patte3, patte3_x1], [Y_origine_patte3, patte3_y1],[0, patte3_z1], 'b', 'LineWidth', 2); % Lien 1
    plot3([patte3_x1, patte3_x2], [patte3_y1, patte3_y2],[patte3_z1, patte3_z2], 'r', 'LineWidth', 2); % Lien 2
    
    % patte 4
    plot3([X_origine_patte4, patte4_x1], [Y_origine_patte4, patte4_y1],[0, patte4_z1], 'b', 'LineWidth', 2); % Lien 1
    plot3([patte4_x1, patte4_x2], [patte4_y1, patte4_y2],[patte4_z1, patte4_z2], 'r', 'LineWidth', 2); % Lien 2
    
    % patte 5
    plot3([X_origine_patte5, patte5_x1], [Y_origine_patte5, patte5_y1],[0, patte5_z1], 'b', 'LineWidth', 2); % Lien 1
    plot3([patte5_x1, patte5_x2], [patte5_y1, patte5_y2],[patte5_z1, patte5_z2], 'r', 'LineWidth', 2); % Lien 2
    
    % patte 6
    plot3([X_origine_patte6, patte6_x1], [Y_origine_patte6, patte6_y1],[0, patte6_z1], 'b', 'LineWidth', 2); % Lien 1
    plot3([patte6_x1, patte6_x2], [patte6_y1, patte6_y2],[patte6_z1, patte6_z2], 'r', 'LineWidth', 2); % Lien 2
    
    % Tracer les joints
    %patte 1
    plot3(X_origine_patte1, Y_origine_patte1, 0, 'ko', 'MarkerFaceColor', 'k'); % Origine
    plot3(patte1_x1, patte1_y1,patte1_z1, 'ko', 'MarkerFaceColor', 'k'); % Joint 1
    plot3(patte1_x2, patte1_y2,patte1_z2, 'ko', 'MarkerFaceColor', 'k'); % Joint 2
    
    %patte 2
    plot3(X_origine_patte2, Y_origine_patte2, 0, 'ko', 'MarkerFaceColor', 'k'); % Origine
    plot3(patte2_x1, patte2_y1,patte2_z1, 'ko', 'MarkerFaceColor', 'k'); % Joint 1
    plot3(patte2_x2, patte2_y2,patte2_z2, 'ko', 'MarkerFaceColor', 'k'); % Joint 2
    
    %patte 3
    plot3(X_origine_patte3, Y_origine_patte3, 0, 'ko', 'MarkerFaceColor', 'k'); % Origine
    plot3(patte3_x1, patte3_y1,patte3_z1, 'ko', 'MarkerFaceColor', 'k'); % Joint 1
    plot3(patte3_x2, patte3_y2,patte3_z2, 'ko', 'MarkerFaceColor', 'k'); % Joint 2
    
    %patte 4
    plot3(X_origine_patte4, Y_origine_patte4, 0, 'ko', 'MarkerFaceColor', 'k'); % Origine
    plot3(patte4_x1, patte4_y1,patte4_z1, 'ko', 'MarkerFaceColor', 'k'); % Joint 1
    plot3(patte4_x2, patte4_y2,patte4_z2, 'ko', 'MarkerFaceColor', 'k'); % Joint 2
    
    %patte 5
    plot3(X_origine_patte5, Y_origine_patte5, 0, 'ko', 'MarkerFaceColor', 'k'); % Origine
    plot3(patte5_x1, patte5_y1,patte5_z1, 'ko', 'MarkerFaceColor', 'k'); % Joint 1
    plot3(patte5_x2, patte5_y2,patte5_z2, 'ko', 'MarkerFaceColor', 'k'); % Joint 2
    
    %patte 6
    plot3(X_origine_patte6, Y_origine_patte6, 0, 'ko', 'MarkerFaceColor', 'k'); % Origine
    plot3(patte6_x1, patte6_y1,patte6_z1, 'ko', 'MarkerFaceColor', 'k'); % Joint 1
    plot3(patte6_x2, patte6_y2,patte6_z2, 'ko', 'MarkerFaceColor', 'k'); % Joint 2

    %Tracer la trajectoire
    plot3(X_traj,Y_traj,Z_traj)
    plot3(xtrace, ytrace, ztrace, 'g');


    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    grid

    % Mise à jour de l'axe
    temps = round(SimOut.JOINT.time(i),2);
    title(['Robot 2 Axe T= ',num2str(temps),' s']);
    pause(pas_temps); % Pause pour une animation fluide
end