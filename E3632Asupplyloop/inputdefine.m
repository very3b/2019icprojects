%�����ʽ��
%���������������硰0.1~20��������
%����������
function [min max]=inputdefine(str)
%ʹ�� '~' �ַ���Ϊ�ָ��������ַ����ĵ�һ���֡�
[min max]=strtok(str,'~');%max�ḳ��~30֮��
%ȷ�� max �Ƿ�Ϊ��
if isempty(max)

varargout(1)=str2num(min);

else
    min=str2num(min);
    max=str2num(max(2:end));%ȥ��~
    a=0;
    if min>max
       a=min;
       min=max;
       max=a;
    end
   
end
