clear
clc

s = serial('COM3');  %定义串口对象
set(s,'BaudRate',9600);  %设置波特率s
fopen(s);  %打开串口对象s
%==============================================================
N=1000;                                %设置校准矩阵长度
%=============================================================
global A G M q0 q1 q2 q3 T halfT  g t
q0=1;q1=0;q2=0;q3=0;                  %4 parameters of the quaternion a,b,c,d,(v=q0+q1i+q2j+q3k)
A_static=[0; 0; 0];                   %initial acceleration
V_static=[0; 0; 0];                   %initial velocity
R_static=[0; 0; 0];                   %initial position
g=9.81;
T=t;
halfT=t/2;
i=0;t=0;                              %for timer usage
A0=zeros(3,N);A1=zeros(3,1);        %for correction
G0=zeros(3,N);G1=zeros(3,1);


while(i<5000)
    if(str2double(fgetl(s))~=0)
        continue
    else
%main part=================================================================
        A=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
        G=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
        M=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
        coordinate_transformation

        
%           vector_transformation
        C=[(q0^2+q1^2-q2^2-q3^2),2*(q1*q2-q0*q3),2*(q1*q3+q0*q2);
            2*(q1*q2+q0*q3),(q0^2-q1^2+q2^2-q3^2),2*(q2*q3-q0*q1);
            2*(q1*q3-q0*q2),2*(q2*q3+q0*q1),(q0^2-q1^2-q2^2+q3^2)];
        Acc=C*A'*g;                %加速度坐标系变换
%get correction with 3*N data----------------------
        if i<N                                               %取样
            A0(1,i+1)=(Acc(1,1));
            A0(2,i+1)=(Acc(2,1));
            A0(3,i+1)=(Acc(3,1));
            i
        elseif i==N                                          %校正算法
            A1(1,1)=polyfit((1:N),A0(1,:),0);
            A1(2,1)=polyfit((1:N),A0(2,:),0);
            A1(3,1)=polyfit((1:N),A0(3,:),0);
        else  
            A_static=Acc-A1;                                  %静止坐标系的：三轴加速度
            V_static=V_static+A_static.*T;                                   %三轴速度
            R_static=R_static+V_static*T+(1/2)*A_static.*T^2;                %三轴位移
        end        
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
%-------------------------------------
    i=i+1;
%=================输出区
%     [yaw, pitch, roll] = quat2angle([q0 q1 q2 q3])
    G
%==================
end

fclose(s)
clear
clc