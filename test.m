s = serial('COM3');  %���崮�ڶ���
set(s,'BaudRate',9600);  %���ò�����s
fopen(s);  %�򿪴��ڶ���s
i=0;

while(i<5000)
    if(str2double(fgetl(s))~=100)
        continue
    else
        A=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
    end
%timer--------------------------------tΪÿ�μ�������ʱ��
    if(i==0)
        tic
    elseif(rem(i,2)==0)
        T=toc;
        tic
    else
        T=toc;
        tic;
    end
%------------------------------------
    i=i+1
    A(1,3)
end