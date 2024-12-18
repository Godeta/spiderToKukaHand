function ANGLE = MGI (POS)
l1 = evalin('base', 'l1'); % Récupère l1 du workspace
l2 = evalin('base', 'l2'); % Récupère l2 du workspace

%Patte 1
x1 = POS(1);
z1 = POS(2);

O2_1 = asin(-z1/l2)-(31*pi/180);
O1_1 = acos(x1/(l1+l2*cos(O2_1+(31*pi/180))));

%Patte 2
x2 = POS(3);
z2 = POS(4);

O2_2 = asin(-z2/l2)-(31*pi/180);
O1_2 = acos(x2/(l1+l2*cos(O2_2+(31*pi/180)))) + pi;

%Patte 3
x3 = POS(5);
z3 = POS(6);

O2_3 = asin(-z3/l2)-(31*pi/180);
O1_3 = acos(x3/(l1+l2*cos(O2_3+(31*pi/180))));

%Patte 4
x4 = POS(7);
z4 = POS(8);

O2_4 = asin(-z4/l2)-(31*pi/180);
O1_4 = acos(x4/(l1+l2*cos(O2_4+(31*pi/180)))) + pi;

%Patte 5
x5 = POS(9);
z5 = POS(10);

O2_5 = asin(-z5/l2)-(31*pi/180);
O1_5 = acos(x5/(l1+l2*cos(O2_5+(31*pi/180))));

%Patte 6
x6 = POS(11);
z6 = POS(12);

O2_6 = asin(-z6/l2)-(31*pi/180);
O1_6 = acos(x6/(l1+l2*cos(O2_6+(31*pi/180)))) + pi;

ANGLE = [O1_1;O2_1;O1_2;O2_2;O1_3;O2_3;O1_4;O2_4;O1_5;O2_5;O1_6;O2_6];
end