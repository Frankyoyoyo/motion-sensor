clear
clc

s = serial('COM4');  %定义串口对象
set(s,'BaudRate',9600);  %设置波特率s
fopen(s);  %打开串口对象s

interval = 100;  %这里开始的代码很Part1里的代码类似

fgetl(s)
A=[str2num(fgetl(s));str2num(fgetl(s));str2num(fgetl(s))]

B=A+[1;2;3]
% while(fgetl(s))
%     A=[fgetl(s),fgetl(s),fgetl(s)]
%     B=[fgetl(s),fgetl(s),fgetl(s)]
%     C=[fgetl(s),fgetl(s),fgetl(s)]
% %     plot(real(b),imag(b),'ro');
% end
% fclose(s);  %关闭串口对象s

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
fclose(s)
