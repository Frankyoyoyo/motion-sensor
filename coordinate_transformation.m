%A=[str2num(fgetl(s));str2num(fgetl(s));str2num(fgetl(s))];
%G=[str2num(fgetl(s));str2num(fgetl(s));str2num(fgetl(s))];
%M=[str2num(fgetl(s));str2num(fgetl(s));str2num(fgetl(s))];

	f=125;               %采样频率/Hz
	Kp=2*f；
	Ki=0.005*f;
	halfT=0.5*f;
	
	q0=1;
	q1=0;
	q2=0;
	q3=0;                %四元数4个参数a,b,c,d,(v=q0+q1i+q2j+q3k)
	
%-------------------------------------------------------------------------
	norm=sqrt(A(1,1)*A(1,1)+A(1,2)*A(1,2)+A(1,3)*A(1,3));
	ax=A(1,1)/norm;
	ay=A(1,2)/norm;
	az=A(1,3)/norm;
	A=[ax;ay;az];
%-------------------------------------------------------------------------	
	norm=sqrt(M(1,1)*M(1,1)+M(1,2)*M(1,2)+M(1,3)*M(1,3));
	mx=M(1,1)/norm;
	my=M(1,2)/norm;
	mz=M(1,3)/norm;
	M=[mx;my;mz];
	                     %对加速度传感器和磁场传感器的数值归一化方便计算
%-------------------------------------------------------------------------
	hx=2*mx*(0.5-q2*q2-q3*q3)+2*my*(q1*q2-q0*q3)+2*mz*(q1*q3+q0*q2);
	hy=2*mx*(q1*q2+q0*q3)+2*my*(0.5-q1*q1-q3*q3)+2*mz*(q2*q3-q0*q1);
	hz=2*mx*(q1*q3-q0*q2)+2*my*(q2*q3+q0*q1)+2*mz*(0.5-q1*q1-q2*q2);
	H=[hx;hy;hz];        %传感器参考系上的地磁矢量转换到静止坐标系后的矢量
	
	bx=sqrt(hx*hx+hy*hy);
	bz=hz;               %误差函数
%-------------------------------------------------------------------------
	vx=2*(q1*q3-q0*q2);
	vy=2*(q0*q1+q2*q3);
	vz=q0*q0-q1*q1-q2*q2-q3*q3;
	V=[vx;vy;vz];        %标准单位重力转换到传感器参考系后各个坐标分量
	
	wx=2*bx*(0.5-q2*q2-q3*q3)+2*bz*(q1*q3-q0*q2);
	wy=2*bx*(q1*q2-q0*q30)+2*bz*(0.5-q1*q1-q2*q2);
	wz=2*bx*(q0*q2+q1*q3)+2*bz*(0.5-q1*q1-q2*q2);
	W=[wx;wy;wz];
	                     %将bx,bz重新转换回传感器坐标系后各个坐标分量
	
	ex = (ay*vz - az*vy) + (my*wz - mz*wy);
	ey = (az*vx - ax*vz) + (mz*wx - mx*wz);
	ez = (ax*vy - ay*vx) + (mx*wy - my*wx);
	E=[ex;ey;ez];        %E为误差向量
						 %描述A和M与V和W的偏差程度（A×V+M×W）
%=========================================================================	
	exInt=exlnt+ex*Ki;
	eyInt=eylnt+ey*Ki;
	ezInt=ezlnt+ez*Ki;   %对误差积分
	
	gx = gx + Kp*ex + exInt;
	gy = gy + Kp*ey + eyInt;
	gz = gz + Kp*ez + ezInt;%用误差的积分和误差本身与Kp的乘积的和对角速度进行补偿
	
	q0 = q0 + (-q1*gx - q2*gy - q3*gz)*halfT;
	q1 = q1 + (q0*gx + q2*gz - q3*gy)*halfT;
	q2 = q2 + (q0*gy - q1*gz + q3*gx)*halfT;
	q3 = q3 + (q0*gz + q1*gy - q2*gx)*halfT;
	                       %龙格库塔法求出四元数的值
						   
	norm = sqrt(q0*q0 + q1*q1 + q2*q2 + q3*q3);
	q0 = q0 / norm;
	q1 = q1 / norm;
	q2 = q2 / norm;
	q3 = q3 / norm;        %四元数归一化
	