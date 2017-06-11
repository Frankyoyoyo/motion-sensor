clear
clc

s = serial('COM5');                   %define serial port
set(s,'BaudRate',9600);               %set baud rate
fopen(s);                             %open serial port s
%==============================================================
N=500;                                %set the length of correcting matrix
%=============================================================
global A G q0 q1 q2 q3 T halfT g G1
q0=1;q1=0;q2=0;q3=0;                  %4 parameters of the quaternion,(v=q0+q1i+q2j+q3k)
A_static=[0; 0; 0];                   %initial acceleration
V_static=[0; 0; 0];                   %initial velocity
R_static=[0; 0; 0];                   %initial position
J=[0,0,1];                           %to make A_static stable
g=9.81;
halfT=T/2;
i=0;T=0;                              %for timer usage
A0=zeros(3,N);A1=zeros(3,1);          %for correction
G0=zeros(N,3);G1=zeros(1,3);          %0-collect data£¬1-correctiong data


while(i<1500)
    if(str2double(fgetl(s))~=100)
        continue
    else
%==================main part===============================================
        A=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
        G=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
%         M=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
        
    coordinate_transformation
    %------------------------
    if i>2*N
        for k=1:3
            if abs(G(1,k))<=0.02
                G(1,k)=0;
            end
        end
    end
    %------------------------
        

    %vector transformation-----------------------------
        C=[(q0^2+q1^2-q2^2-q3^2),2*(q1*q2-q0*q3),2*(q1*q3+q0*q2);
            2*(q1*q2+q0*q3),(q0^2-q1^2+q2^2-q3^2),2*(q2*q3-q0*q1);
            2*(q1*q3-q0*q2),2*(q2*q3+q0*q1),(q0^2-q1^2-q2^2+q3^2)];
        Acc=C*A'*g;                                          %vector transformation of acceleration

    %get correction with 3*N data----------------------
        if i<N                                               %sampling
            G0(i+1,1)=(G(1,1));
            G0(i+1,2)=(G(1,2));
            G0(i+1,3)=(G(1,3));
        elseif i==N                                          %correcting algorithm£¨curve fitting/average value£©
%             G1(1,1)=polyfit((1:N),G0(:,1)',0);
%             G1(1,2)=polyfit((1:N),G0(:,2)',0);
%             G1(1,3)=polyfit((1:N),G0(:,3)',0);
            G1(1,1)=1/N*sum(G0(:,1));
            G1(1,2)=1/N*sum(G0(:,2));
            G1(1,3)=1/N*sum(G0(:,3));
            q0=1;q1=0;q2=0;q3=0;                             %reset quaternion
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
            A_static=Acc-A1;                                  %static coordinate system£ºacceleration
            V_static=V_static+A_static*T;                     %                          velocity
        %----------------------------------
                if abs(sum(A(1,:).^2)-1)<0.04
                    A_static=[0;0;0];
                end
            for j=1:3
                if abs(A_static(j,1))<0.03
                    V_static(j,1)=0;
                end
            end
        %----------------------------------
            R_static=R_static+V_static*T+(1/2)*A_static*T^2;  %                          displacement
        end        
    end
    %--------------timer------------------(T is the period of each calculation)
    if(i==0)
        tic
    elseif(rem(i,2)==0)
        T=toc;
        tic
    else
        T=toc;
        tic;
    end
%=================output area================================
    i
    A
    plot3(R_static(1,1),R_static(2,1),R_static(3,1),'r.','MarkerSize',80);
    axis([-2 2 -2 2 0 4]);
    drawnow

%    [yaw, pitch, roll] = quat2angle([q0 q1 q2 q3]);
%    plot(i,roll/3.14159*180,'or')
%    hold on
%    axis([1000 1500 -120 120])
% %    title('roll(¡ã)-i')
%    drawnow

%------------debugging-----------------
%    G   
% 	 A_static
%    V_static
%    Acc
%    [yaw, pitch, roll] = quat2angle([q0 q1 q2 q3]);
%    plot(i,roll/3.14159*180,'or')
%    hold on
%    axis([1000 2000 -120 120])
%    title('roll(¡ã)-i')
%    drawnow

%    V_static
%    R_static

%    plot(i,A(1,3),'or')
%    hold on
%    axis([1000 2000 0 2])
%    drawnow
%    A(1,3)
%    Acc
%===========================================================================
    i=i+1;
end

fclose(s)
