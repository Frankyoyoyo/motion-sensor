clear
clc

s = serial('COM4');  %���崮�ڶ���
set(s,'BaudRate',9600);  %���ò�����s
fopen(s);  %�򿪴��ڶ���s

interval = 100;  %���￪ʼ�Ĵ����Part1��Ĵ�������

while(1)
    fgetl(s)
    A=[str2num(fgetl(s));str2num(fgetl(s));str2num(fgetl(s))];
    G=[str2num(fgetl(s));str2num(fgetl(s));str2num(fgetl(s))];
    M=[str2num(fgetl(s));str2num(fgetl(s));str2num(fgetl(s))];
end
% while(fgetl(s))
%     A=[fgetl(s),fgetl(s),fgetl(s)]
%     B=[fgetl(s),fgetl(s),fgetl(s)]
%     C=[fgetl(s),fgetl(s),fgetl(s)]
% %     plot(real(b),imag(b),'ro');
% end
% fclose(s);  %�رմ��ڶ���s

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
