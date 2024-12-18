function JOINT = MGD(ANGLE)
l1 = evalin('base', 'l1'); % Récupère l1 du workspace
l2 = evalin('base', 'l2'); % Récupère l2 du workspace

%Patte 1
O1_1 = ANGLE(1);
O2_1 = ANGLE(2);

patte1_x1 = l1*cos(O1_1);
patte1_y1 = l1*sin(O1_1);
patte1_z1 = 0;

patte1_x2 = cos(O1_1)*(l1 + l2*cos(O2_1+(31*pi/180)));
patte1_y2 = sin(O1_1)*(l1 + l2*cos(O2_1+(31*pi/180)));
patte1_z2 = -l2*sin(O2_1+(31*pi/180));

Patte1=[patte1_x1;patte1_y1;patte1_z1;patte1_x2;patte1_y2;patte1_z2];

%Patte 2
O1_2 = ANGLE(3);
O2_2 = ANGLE(4);

patte2_x1 = l1*cos(O1_2);
patte2_y1 = l1*sin(O1_2);
patte2_z1 = 0;

patte2_x2 = cos(O1_2)*(l1 + l2*cos(O2_2+(31*pi/180)));
patte2_y2 = sin(O1_2)*(l1 + l2*cos(O2_2+(31*pi/180)));
patte2_z2 = -l2*sin(O2_2+(31*pi/180));

Patte2=[patte2_x1;patte2_y1;patte2_z1;patte2_x2;patte2_y2;patte2_z2];

%Patte 3
O1_3 = ANGLE(5);
O2_3 = ANGLE(6);

patte3_x1 = l1*cos(O1_3);
patte3_y1 = l1*sin(O1_3);
patte3_z1 = 0;

patte3_x2 = cos(O1_3)*(l1 + l2*cos(O2_3+(31*pi/180)));
patte3_y2 = sin(O1_3)*(l1 + l2*cos(O2_3+(31*pi/180)));
patte3_z2 = -l2*sin(O2_3+(31*pi/180));

Patte3=[patte3_x1;patte3_y1;patte3_z1;patte3_x2;patte3_y2;patte3_z2];

%Patte 4
O1_4 = ANGLE(7);
O2_4 = ANGLE(8);

patte4_x1 = l1*cos(O1_4);
patte4_y1 = l1*sin(O1_4);
patte4_z1 = 0;

patte4_x2 = cos(O1_4)*(l1 + l2*cos(O2_4+(31*pi/180)));
patte4_y2 = sin(O1_4)*(l1 + l2*cos(O2_4+(31*pi/180)));
patte4_z2 = -l2*sin(O2_4+(31*pi/180));

Patte4=[patte4_x1;patte4_y1;patte4_z1;patte4_x2;patte4_y2;patte4_z2];

%Patte 5
O1_5 = ANGLE(9);
O2_5 = ANGLE(10);

patte5_x1 = l1*cos(O1_5);
patte5_y1 = l1*sin(O1_5);
patte5_z1 = 0;

patte5_x2 = cos(O1_5)*(l1 + l2*cos(O2_5+(31*pi/180)));
patte5_y2 = sin(O1_5)*(l1 + l2*cos(O2_5+(31*pi/180)));
patte5_z2 = -l2*sin(O2_5+(31*pi/180));

Patte5=[patte5_x1;patte5_y1;patte5_z1;patte5_x2;patte5_y2;patte5_z2];

%Patte 6
O1_6 = ANGLE(11);
O2_6 = ANGLE(12);

patte6_x1 = l1*cos(O1_6);
patte6_y1 = l1*sin(O1_6);
patte6_z1 = 0;

patte6_x2 = cos(O1_6)*(l1 + l2*cos(O2_6+(31*pi/180)));
patte6_y2 = sin(O1_6)*(l1 + l2*cos(O2_6+(31*pi/180)));
patte6_z2 = -l2*sin(O2_6+(31*pi/180));

Patte6=[patte6_x1;patte6_y1;patte6_z1;patte6_x2;patte6_y2;patte6_z2];



JOINT = [Patte1;Patte2;Patte3;Patte4;Patte5;Patte6];
end