%连接PXA
visaObj=visa('agilent','TCPIP0::192.168.2.213::inst0::INSTR');
% addressline=sprintf('');
% eval(addressline);
set(visaObj, 'InputBufferSize', 100000);
set(visaObj, 'Timeout', 30);
fopen(visaObj);

%环境初始化
fprintf(visaObj,':SYST:PRES');
fprintf(visaObj,'*CLS');

% Query Instrument Identification Information
fprintf(visaObj, '*RST');
instrumentInfo = query(visaObj, '*IDN?');
disp(['Instrument identification information: ' instrumentInfo]);
% Mode->spectrum analyzer
fprintf(visaObj,'Instrument:Select SA');
% Auto tune
fprintf(visaObj,':SENSe:FREQuency:TUNE:Immediate');
% 设置输出数据格式为ASCii
fprintf(visaObj,':FORMat:TRACe:DATA ASCII');
fprintf(visaObj,':FORMat:BORDer SWAPPED');

% Read Magnitude and Frequency
% Magnitude=query(visaObj,':Measure:CHPower:CHPower?');
Magnitude=query(visaObj,':Calculate:Marker1:Y?');
Magnitude=roundn(str2num(Magnitude),-4);
CentFreq=query(visaObj,'SENSE:FREQUENCY:CENTER?');
% CentFreq=str2num(CentFreq);
CentFreq=roundn(str2num(CentFreq),-4);

% fprintf(visaObj,'INIT:EVM');
% fprintf(visaObj,':RAD:STAN AC80');
% fprintf(visaObj,':SENSe:EVM:OPT');
% evm=query(visaObj,'FETC:EVM?');

% Close and delete instrument connections
fclose(visaObj); 
delete(visaObj);
clear visaObj