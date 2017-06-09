clear
clc

s = serial('COM5');                   %define serial port
set(s,'BaudRate',9600);               %set baud rate
fopen(s);                             %open serial port s
%==============================================================
N=512;                                %set the length of correcting matrix
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
G0=zeros(N,3);G1=zeros(1,3);          %0-collect data，1-correctiong data
F=zeros(3,N);                         %save data to carry out fft
P=zeros(3,N);
Q=1:N;

while(i<2500)
    if(str2double(fgetl(s))~=100)
        continue
    else
%==================main part===============================================
        A=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
        G=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
        
    coordinate_transformation
    %------------------------
    if i>2*N
        for j=1:3
            if abs(G(1,j))<=0.02
                G(1,j)=0;
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
        if i<N
            G0(i+1,1)=(G(1,1));
            G0(i+1,2)=(G(1,2));
            G0(i+1,3)=(G(1,3));
            
        elseif i==N
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
            for(j=1:3)
                A1=abs(fft(A0(j,:)));
                for(k=1:N)
                    if(fftx(1,k)<0.8)
                    A1(j,k)=0;
                    end
                end
                A1(j,:)=ifft(A1(j,:))
            end
            
        elseif i<(3*N)
            A_static=Acc-A1;                                  %static coordinate system：acceleration

            for(j=1:3)
                F(j,i-2*N)=A_static(j,1);
            end                                                %fft所用数组的存储（定义）
        elseif i==(3*N)
            for(j=1:3)
                F(j,N)=A_static(j,1);
                P(j,:)=abs(fft(F(j,:)));
%                 for(k=1:N)
%                     if(P(j,k)<0.1)
%                         P(j,k)=0;
%                     end
%                 end
                F(j,:)=ifft(P(j,:));
                A_static(j,1)=F(j,N);
            end
            
        else                %i>3*N
            F=circshift(F,[0,-1]);
            F(:,N)=A_static;
            for(j=1:3)
                P(j,:)=abs(fft(F(j,:)));
                for(k=1:N)
                    if(P(j,k)<0.1)
                        P(j,k)=0;
                    end
                end
                F(j,:)=ifft(P(j,:));
                A_static(j,1)=F(j,N);
%                V_static=V_static+A_static*T;                     %                          velocity
%                R_static=R_static+V_static*T+(1/2)*A_static*T^2;  %                          displacement
            end
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
%     plot3(R_static(1,1),R_static(2,1),R_static(3,1),'o');
%     axis([-0.5 0.5 -0.5 0.5 -0.5 0.5]);
%     drawnow
%------------debugging-----------------
%    G

	 A_static
%    V_static
%    Acc
%    [yaw, pitch, roll] = quat2angle([q0 q1 q2 q3]);

%    plot(i,roll/3.14159*180,'or')
%    hold on
%    axis([1000 2000 -120 120])
%    title('roll(°)-i')
%    drawnow

h=plot(Q,P(2,:));
drawnow
delete(h)
%===========================================================================
    i=i+1;
end

fclose(s)
