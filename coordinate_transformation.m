% function coordinate_transformation             
	Kp=2;
	Ki=0.01;
    halfT=T/2;
    global A G M q0 q1 q2 q3 halfT T g G1
    G=G-G1;
	exInt=0;eyInt=0;ezInt=0;
    
%debugging------------------------------------------   
%     A=[1,0,1];
%     G=[1,1,0];
%     M=[1,0,0];
%     q0=1;q1=0;q2=0;q3=0;
%     Vx=0;Vy=0;Vz=0; 
%     halfT=0.03;
%     X=0;Y=0;Z=0;
%     g=9.81;
%-------------------------------------------------------------------------
	norm=sqrt(A(1,1)*A(1,1)+A(1,2)*A(1,2)+A(1,3)*A(1,3));
	ax=A(1,1)/norm;
	ay=A(1,2)/norm;
	az=A(1,3)/norm;
%-------------------------------------------------------------------------	
% 	norm=sqrt(M(1,1)*M(1,1)+M(1,2)*M(1,2)+M(1,3)*M(1,3));
% 	mx=M(1,1)/norm;
% 	my=M(1,2)/norm;
% 	mz=M(1,3)/norm;       
%
% 	hx=2*mx*(0.5-q2*q2-q3*q3)+2*my*(q1*q2-q0*q3)+2*mz*(q1*q3+q0*q2);
% 	hy=2*mx*(q1*q2+q0*q3)+2*my*(0.5-q1*q1-q3*q3)+2*mz*(q2*q3-q0*q1);
% 	hz=2*mx*(q1*q3-q0*q2)+2*my*(q2*q3+q0*q1)+2*mz*(0.5-q1*q1-q2*q2);     
%     
% 	bx=sqrt(hx*hx+hy*hy);
% 	bz=hz;            
%-------------------------------------------------------------------------
	vx=2*(q1*q3-q0*q2);
	vy=2*(q0*q1+q2*q3);
	vz=q0*q0-q1*q1-q2*q2-q3*q3;     %components of gravity on sensor coordinate system
	
% 	wx=2*bx*(0.5-q2*q2-q3*q3)+2*bz*(q1*q3-q0*q2);
% 	wy=2*bx*(q1*q2-q0*q3)+2*bz*(0.5-q1*q1-q2*q2);
% 	wz=2*bx*(q0*q2+q1*q3)+2*bz*(0.5-q1*q1-q2*q2);
% 	W=[wx,wy,wz];
	                   
	
% 	ex = (ay*vz - az*vy) + (my*wz - mz*wy);
% 	ey = (az*vx - ax*vz) + (mz*wx - mx*wz);
% 	ez = (ax*vy - ay*vx) + (mx*wy - my*wx);

	ex = (ay*vz - az*vy);
	ey = (az*vx - ax*vz);
	ez = (ax*vy - ay*vx);          %E=A¡ÁM+V¡ÁW, express the degree of deviation
%===========================PID algorithm====================================
	exInt=exInt+ex*Ki;
	eyInt=eyInt+ey*Ki;
	ezInt=ezInt+ez*Ki;             %error integration

	gx = G(1,1) + Kp*ex + exInt;
	gy = G(1,2) + Kp*ey + eyInt;
	gz = G(1,3) + Kp*ez + ezInt;
%======================quaternion calculation================================
	q0 = q0 + (-q1*gx - q2*gy - q3*gz)*halfT;
	q1 = q1 + (q0*gx + q2*gz - q3*gy)*halfT;
	q2 = q2 + (q0*gy - q1*gz + q3*gx)*halfT;
	q3 = q3 + (q0*gz + q1*gy - q2*gx)*halfT;

		   
    norm = sqrt(q0*q0 + q1*q1 + q2*q2 + q3*q3);
    q0 = q0 / norm;
    q1 = q1 / norm;
    q2 = q2 / norm;
    q3 = q3 / norm;
 
% [yaw, pitch, roll] = quat2angle([q0 q1 q2 q3])

% end