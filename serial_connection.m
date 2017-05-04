clear
clc

s = serial('COM3');  %定义串口对象
set(s,'BaudRate',9600);  %设置波特率s
fopen(s);  %打开串口对象s

while(1)
    fgetl(s);
    A=[str2num(fgetl(s));str2num(fgetl(s));str2num(fgetl(s))];
    G=[str2num(fgetl(s));str2num(fgetl(s));str2num(fgetl(s))];
    M=[str2num(fgetl(s));str2num(fgetl(s));str2num(fgetl(s))];
end

fclose(s)
