clear
clc

s = serial('COM3');  %定义串口对象
set(s,'BaudRate',9600);  %设置波特率s
fopen(s);  %打开串口对象s

global A G M q0 q1 q2 q3 X Y Z T halfT Vx Vy Vz g t
% T=0.008;halfT=0.004;
q0=1;q1=0;q2=0;q3=0;                %4 parameters of the quaternion a,b,c,d,(v=q0+q1i+q2j+q3k)
Vx=0;Vy=0;Vz=0;              %initial velocity
X=0;Y=0;Z=0;                %initial position
g=9.81;
i=0;t=0;                    %for timer usage
T=t;
halfT=t/2;
while(1)
    if(str2double(fgetl(s))~=0)
        continue
    else
        A=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
        G=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
        M=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
        coordinate_transformation
%         [yaw, pitch, roll] = quat2angle([q0 q1 q2 q3])
        
        vector_transformation
        Ax
        Ay
        Az
     
    end
    
%timer--------------------------------t为每次计算所用时间
    if(i==0)
        tic
    elseif(rem(i,2)==0)
        t=toc;
        tic
    else
        t=toc;
        tic;
    end
    i=i+1;
%-------------------------------------
end

fclose(s)
clear
clc