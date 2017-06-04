clear
clc

s = serial('COM3');  %定义串口对象
set(s,'BaudRate',9600);  %设置波特率s
fopen(s);  %打开串口对象s
%==============================================================
N=500;                                %设置校准矩阵长度
%=============================================================
global A G q0 q1 q2 q3 T halfT g G1
q0=1;q1=0;q2=0;q3=0;                  %4 parameters of the quaternion a,b,c,d,(v=q0+q1i+q2j+q3k)
A_static=[0; 0; 0];                   %initial acceleration
V_static=[0; 0; 0];                   %initial velocity
R_static=[0; 0; 0];                   %initial position
g=9.81;
halfT=T/2;
i=0;T=0;                              %for timer usage
A0=zeros(3,N);A1=zeros(3,1);        %for correction
G0=zeros(N,3);G1=zeros(1,3);        %0收集数据，1为校正值


while(i<5000)
    if(str2double(fgetl(s))~=100)
        continue
    else
%main part=================================================================
        A=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
        G=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
%         M=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
        
    coordinate_transformation

        
%vector transformation-------------------------------------------------
        C=[(q0^2+q1^2-q2^2-q3^2),2*(q1*q2-q0*q3),2*(q1*q3+q0*q2);
            2*(q1*q2+q0*q3),(q0^2-q1^2+q2^2-q3^2),2*(q2*q3-q0*q1);
            2*(q1*q3-q0*q2),2*(q2*q3+q0*q1),(q0^2-q1^2-q2^2+q3^2)];
        Acc=C*A'*g;                %加速度坐标系变换
%get correction with 3*N data----------------------
        if i<N                                               %取样
            G0(i+1,1)=(G(1,1));
            G0(i+1,2)=(G(1,2));
            G0(i+1,3)=(G(1,3));
        elseif i==N                                          %校正算法（曲线拟合/平均值）
%             G1(1,1)=polyfit((1:N),G0(:,1)',0);
%             G1(1,2)=polyfit((1:N),G0(:,2)',0);
%             G1(1,3)=polyfit((1:N),G0(:,3)',0);
            G1(1,1)=1/N*sum(G0(:,1));
            G1(1,2)=1/N*sum(G0(:,2));
            G1(1,3)=1/N*sum(G0(:,3));
            q0=1;q1=0;q2=0;q3=0;
            A0(1,i-N+1)=(Acc(1,1));
            A0(2,i-N+1)=(Acc(2,1));
            A0(3,i-N+1)=(Acc(3,1));
        elseif i<(2*N)
            A0(1,i-N+1)=(Acc(1,1));
            A0(2,i-N+1)=(Acc(2,1));
            A0(3,i-N+1)=(Acc(3,1));
        elseif i==(2*N)
            A1(1,1)=polyfit((1:N),A0(1,:),0);
            A1(2,1)=polyfit((1:N),A0(2,:),0);
            A1(3,1)=polyfit((1:N),A0(3,:),0);
        else  
            A_static=Acc-A1;                                  %静止坐标系的：三轴加速度

            V_static=V_static+A_static*T;                                   %三轴速度
            R_static=R_static+V_static*T+(1/2)*A_static*T^2;                %三轴位移
        end        
    end
%timer--------------------------------t为每次计算所用时间
    if(i==0)
        tic
    elseif(rem(i,2)==0)
        T=toc;
        tic
    else
        T=toc;
        tic;
    end
%-------------------------------------
    i=i+1;
%=================输出区
%     [yaw, pitch, roll] = quat2angle([q0 q1 q2 q3])
    i
    T
%     V_static
%     plot3(R_static(1,1),R_static(2,1),R_static(3,1),'o');
%     axis([-2 2 -2 2 -2 2]);
%     axis equal
%     drawnow

%     plot(i,A_static(2,1),'o')
    plot(i,A(1,3),'or')
    hold on
    axis([1000 1500 0 2])
    drawnow
%     A(1,3)
%     Acc
%==================
end

fclose(s)
clear
clc