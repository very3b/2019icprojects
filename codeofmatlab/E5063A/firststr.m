function firstline=firststr()
visaObj=instrfind;
idn=query(visaObj,'*IDN?');

firstline=sprintf('!%s',idn);
end