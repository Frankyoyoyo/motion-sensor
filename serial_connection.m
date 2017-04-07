clear
clc

s = serial('COM3');  %定义串口对象
set(s,'BaudRate',9600);  %设置波特率s
fopen(s);  %打开串口对象s

interval = 100;  %这里开始的代码很Part1里的代码类似
passo = 1;
t = 1;
x = 0;
while(t<interval)
    b = fgetl(s) %用函数fget(s)从缓冲区读取串口数据，当出现终止符（换行符）停止。
    
end
fclose(s);  %关闭串口对象s

% clear
% clc
% 
% s=serial('COM3');
% set(s,'BaudRate',9600); 
% fopen(s); 
% 
% a=fgetl(s);
% h=plot(a,'.');
% set(h,'EraseMode','xor')
% for i=0:100
%     a = fgetl(s);
%     drawnow;
% end
% 
% fclose(s); 
