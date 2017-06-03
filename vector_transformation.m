% function vector_transformation
global A q0 q1 q2 q3  g t X Y Z T Vx Vy Vz
T=t;

%debugging------------------------------------------   
%     A=[1,1,1];
%     G=[1,1,0];
%     M=[1,0,0];
%     q0=1;q1=0;q2=0;q3=0;
%     Vx=0;Vy=0;Vz=0; 
%     T=0.066;halfT=0.033;
%     X=0;Y=0;Z=0;
%     g=9.81;
%-------------------------------------------------------	

C=[(q0^2+q1^2-q2^2-q3^2),2*(q1*q2-q0*q3),2*(q1*q3+q0*q2);
    2*(q1*q2+q0*q3),(q0^2-q1^2+q2^2-q3^2),2*(q2*q3-q0*q1);
    2*(q1*q3-q0*q2),2*(q2*q3+q0*q1),(q0^2-q1^2-q2^2+q3^2)];
    
Acc=C*A';                %加速度坐标系变换

Ax=Acc(1,1)*g;
Ay=Acc(2,1)*g;
Az=Acc(3,1)*g;    %静止坐标系三轴加速度


Vx=Vx+Ax*T;               %三轴速度
Vy=Vy+Ay*T;
Vz=Vz+Az*T;
    
X=X+Vx*T+(1/2)*Ax*T^2;        %三轴位移
Y=Y+Vy*T+(1/2)*Ay*T^2;
Z=Z+Vz*T+(1/2)*Az*T^2;
     
% plot3(X,Y,Z);
% end
