s = serial('COM3');  %定义串口对象
set(s,'BaudRate',9600);  %设置波特率s
fopen(s);  %打开串口对象s
i=0;

while(i<5000)
    if(str2double(fgetl(s))~=100)
        continue
    else
        A=[str2double(fgetl(s)),str2double(fgetl(s)),str2double(fgetl(s))];
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
%------------------------------------
    i=i+1
    A(1,3)
end