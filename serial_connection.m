clear
clc

s = serial('COM3');  %���崮�ڶ���
set(s,'BaudRate',9600);  %���ò�����s
fopen(s);  %�򿪴��ڶ���s

interval = 100;  %���￪ʼ�Ĵ����Part1��Ĵ�������
passo = 1;
t = 1;
x = 0;
while(t<interval)
    b = str2num(fgetl(s));  %�ú���fget(s)�ӻ�������ȡ�������ݣ���������ֹ�������з���ֹͣ��
    x = [x,b];                       %������Arduino������Ҫʹ��Serial.println()
    plot(x);
    grid
    t = t+passo;
    drawnow;
    
end
fclose(s);  %�رմ��ڶ���s

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
