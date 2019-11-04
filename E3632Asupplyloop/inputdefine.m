%输入格式化
%用于整理输入型如“0.1~20”的数据
%并进行排序
function [min max]=inputdefine(str)
%使用 '~' 字符作为分隔符返回字符串的第一部分。
[min max]=strtok(str,'~');%max会赋予~30之类
%确定 max 是否为空
if isempty(max)

varargout(1)=str2num(min);

else
    min=str2num(min);
    max=str2num(max(2:end));%去掉~
    a=0;
    if min>max
       a=min;
       min=max;
       max=a;
    end
   
end
