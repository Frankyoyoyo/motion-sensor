clear
clc

s = serial('COM3');  %���崮�ڶ���
set(s,'BaudRate',9600);  %���ò�����s
fopen(s);  %�򿪴��ڶ���s

while(1)
    fgetl(s);
    A=[str2num(fgetl(s));str2num(fgetl(s));str2num(fgetl(s))];
    G=[str2num(fgetl(s));str2num(fgetl(s));str2num(fgetl(s))];
    M=[str2num(fgetl(s));str2num(fgetl(s));str2num(fgetl(s))];
end

fclose(s)
