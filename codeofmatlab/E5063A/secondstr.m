function secondline=secondstr()
[daynum,dayname]=weekday(date);
[day,rest]=strtok(date,'-');
[month,rest]=strtok(rest,'-');
[year,rest]=strtok(rest,'-');

t=fix(datevec(datenum(clock)));
y=num2str(t(1));
m=num2str(t(2));
d=num2str(t(3));
h=num2str(t(4));
mn=num2str(t(5));
s=num2str(t(6));

secondline=sprintf('!Date: %s %s %s %s:%s:%s %s',dayname,month,day,h,mn,s,year);
end
