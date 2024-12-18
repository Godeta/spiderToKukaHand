function POS = trajectoire (t)
t_total = evalin('base', 't_total'); % Récupère l1 du workspace
[l,c] = size(t_total);

Hauteur_robot = -8.5;
%Traj avance
A = -1/16;
B = 0;
C = Hauteur_robot+1;

%Traj_tracte
a = 8/5;
b = -4;

if t < (t_total(c)/2)+0.1
    %Souleve
    x1 = a*t+b;
    z1 = A*x1^2 + B*x1 + C;
    
    x4 = -x1;
    z4 = z1;

    x5 = x1;
    z5 = z1;

    %Avance
    x2 = 0;
    z2 = Hauteur_robot;

    x3 = x2;
    z3 = z2;

    x6 = x2;
    z6 = z2;

else
    %Souleve
    x2 = 0;
    z2 = Hauteur_robot;

    x3 = x2;
    z3 = z2;

    x6 = x2;
    z6 = z2;

    %Avance
    x1 = -(a*t+b*3);
    z1 = A*b^2 + B*b + C;
    
    x4 = -x1;
    z4 = z1;

    x5 = x1;
    z5 = z1;
end

POS = [x1;z1;x2;z2;x3;z3;x4;z4;x5;z5;x6;z6];
end