clear;
clc;
close all;

syms A B C a b

%Définition des condition
interval_min = -4;
interval_max = 4;
sommet_max = 1;

t_max = 5;

%
delta = B^2-4*A*C;
x_sommet = -B/(2*A);

%Définition du systeme
AVeq1 = (-B+sqrt(delta))/(2*A) == interval_min;
AVeq2 = (-B-sqrt(delta))/(2*A) == interval_max;
AVeq3 = A*x_sommet^2+B*x_sommet+C == sommet_max;
AVeqns = [AVeq1,AVeq2,AVeq3];
AVvars = [A, B, C];

%Résolution d'équation
[solA, solB, solC]= solve(AVeqns,AVvars);
Avance = [solA, solB, solC]

AReq1 = a*0+b == interval_min;
AReq2 = a*t_max + b == interval_max;
AReqns = [AReq1,AReq2];
ARvars = [a, b];
[sola, solb]= solve(AReqns,ARvars);
Tracte = [sola ;solb]


%affichage de la fonction
x = interval_min:0.1:interval_max;
y = (x-x)+0.5;
z = solA(1)*x.^2 + solB(1)*x + solC(1);

plot3(x,y,z)
title(sprintf('A= %0.2f ; B= %0.2f ; C= %0.2f',solA(1),solB(1),solC(1)))
xlabel('X(t)')
ylabel('Y(t)')
zlabel('Z(t)')

