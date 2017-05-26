clear
clc

s = serial('COM3');  %���崮�ڶ���
set(s,'BaudRate',9600);  %���ò�����s
fopen(s);  %�򿪴��ڶ���s
global A G M q0 q1 q2 q3
q0=1;
q1=0;
q2=0;
q3=0;                %4 parameters of the quaternion a,b,c,d,(v=q0+q1i+q2j+q3k)

while(1)
    fgetl(s);
    A=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
    G=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
    M=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];

    coordinate_transformation

end

fclose(s)
clear
clc