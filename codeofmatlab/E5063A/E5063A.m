%�˳�����������SNP
%�˳��򲻰���У׼
% Define instrument VISA address. The VISA address of the instrument
% may be obtained from the instrument's user interface or your VISA
% configuration utility
%instrumentVISAAddress = 'TCPIP0::169.254.109.252::inst0::INSTR';
% Define frequency range of 2.3GHz to 2.6GHz
frequencyRange = [2e9 3e9];
% Number of points in measurement
numPoints = 1001;

% Create a VISA connection to interface with instrument

oldObjects=instrfind;
if ~isempty(oldObjects)
    delete(oldObjects);
    clear oldObjects;
end
resourceStruct = instrhwinfo('visa','agilent'); 

visaObj=visa('agilent', 'TCPIP0::192.168.10.153::inst0::INSTR');
set(visaObj, 'InputBufferSize', 10e6);
set(visaObj, 'Timeout', 30);
fopen(visaObj);


% Display information about instrument
IDNString = query(visaObj,'*IDN?');
fprintf('Connected to: %s\n',IDNString);


% Perform a System Preset
fprintf(visaObj,':SYST:PRES');%E5063A
%fprintf(visaObj,'SYSTem:FPReset');
fprintf(visaObj,'*CLS');

% Wait till system is ready as Preset could take time
opcStatus = 0;
while(~opcStatus)
    opcStatus = str2double(query(visaObj, '*OPC?'));
end

% Define a measurement name and parameter
fprintf(visaObj,':CALCulate1:PARameter:COUNt 1');
fprintf(visaObj,':CALCulate1:PARameter:COUNt 2');
fprintf(visaObj,':CALCulate1:PARameter:COUNt 3');
fprintf(visaObj,':CALCulate1:PARameter:COUNt 4');

%fprintf(visaObj,'CALC:PAR:DEF:EXT ''SParamMeasurementS11'',S11');
%ch=1,���������channel�Ļ���channelĬ��Ϊ1
%ENA���﷨:CALCulate<Ch>:PARameter<Tr>:DEFine {S11|S21|S12|S22}

fprintf(visaObj,':CALC1:PAR1:DEF S11');
fprintf(visaObj,':CALC1:PAR2:DEF S21');
fprintf(visaObj,':CALC1:PAR3:DEF S12');
fprintf(visaObj,':CALC1:PAR4:DEF S22');
fprintf(visaObj,':CALCulate1:PARameter1:SPORt 1');
fprintf(visaObj,':CALCulate1:PARameter2:SPORt 1');
fprintf(visaObj,':CALCulate1:PARameter3:SPORt 2');
fprintf(visaObj,':CALCulate1:PARameter4:SPORt 2');

% Create a new display window and turn it on
%fprintf(visaObj,'DISPlay:WINDow1:STATE ON');%ENAӦ���ò��Ͽ����ڵĹ���
%�����
fprintf(visaObj,':DISPlay:WINDow1:ACTivate');
fprintf(visaObj,':DISPlay:WIND:TRAC1:STAT 1');%�ޱ�������ָ֪���Ƿ�Ե�
fprintf(visaObj,':DISPlay:WIND:TRAC1:STAT 2');
fprintf(visaObj,':DISPlay:WIND:TRAC1:STAT 3');
fprintf(visaObj,':DISPlay:WIND:TRAC1:STAT 4');

fprintf(visaObj,':CALCulate1:PARameter1:SELect')
fprintf(visaObj,':CALCulate1:PARameter2:SELect')
fprintf(visaObj,':CALCulate1:PARameter3:SELect')
fprintf(visaObj,':CALCulate1:PARameter4:SELect')



% Turn ON the Title, Frequency, and Trace Annotation to allow for
% visualization of the measurements on the instrument display


% Turn OFF averaging
fprintf(visaObj,'SENS1:AVER:STAT OFF');%�ù���Ӧ����ͨ�ù���ENAҲ����

% Set the number of points
fprintf(visaObj, sprintf('SENSe:SWEep:POINts %s',num2str(numPoints)));

% Set the frequency ranges
%����Ƶ�ʷ�Χ�������������ɨƵ��Χ�Ļ�Ĭ��Ϊ�����20HZ~4.5GHZ,����ENA��˵
fprintf(visaObj, sprintf(':SENS:FREQ:STAR %s',num2str(frequencyRange(1))));
fprintf(visaObj, sprintf(':SENS:FREQ:STOP %s',num2str(frequencyRange(2))));

% Select measurements and set measurement trigger to immediate

fprintf(visaObj,':TRIGger:SOURce INTernal');
% Select a single sweep across the frequency range to trigger a measurement
fprintf(visaObj,':SENSe1:SWEep:TYPE LINear');

% Autoscale display

% Select a single sweep across the frequency range to trigger a measurement

% Since the instrument may take time to make the measurement, wait until it
% is done before requesting measurement data
opcStatus = 0;
while(~opcStatus)
    opcStatus = str2double(query(visaObj, '*OPC?'));
end
fprintf(visaObj, ':FORMat:DATA ASCii');

% Set byte order to swapped (little-endian) format. SWAPped is required
% when using IBM compatible computers
fprintf(visaObj, 'FORMat:BORDer SWAP');
% Request 2-port measurement data from instrument
S11=query(visaObj,':CALCulate1:TRACe1:DATA:SDATa?');
S21=query(visaObj,':CALCulate1:TRACe2:DATA:SDATa?');
S12=query(visaObj,':CALCulate1:TRACe3:DATA:SDATa?');
S22=query(visaObj,':CALCulate1:TRACe4:DATA:SDATa?');

%���ļ������ʽ����Ϊ
fprintf(visaObj,':MMEMory:STORe:SNP:FORMat RI')
fprintf(visaObj,':MMEM:STOR:SNP:TYPE:S2P 1,2; :MMEMory:STORe:SNP "C:\Users\Administrator\Desktop\TS2.s2p"');

%���ַ�������ת����ֵ

S11=str2num(S11);
S21=str2num(S21);
S12=str2num(S12);
S22=str2num(S22);

%��ȡƵ�㣬��Ӧ��S2P�ļ���һ������
FreqPoint=query(visaObj,':SENSe1:FREQuency:DATA?');
FreqPoint=str2num(FreqPoint);

%����Ԥ����
r=length(FreqPoint);
outarray=zeros(r,9);
outarray(:,1)=FreqPoint';

%�ֱ���ȡS11��ʵ�����鲿
x=1;y=1;
for i=1:length(S11)
    if rem(i,2)
    realS11(x)=S11(i);
    x=x+1;
    else
    imagS11(y)=S11(i);
    y=y+1;
    end
end
outarray(:,2)=realS11;
outarray(:,3)=imagS11;
%�ֱ���ȡS21��ʵ�����鲿
x=1;y=1;
for i=1:length(S21)
    if rem(i,2)
    realS21(x)=S21(i);
    x=x+1;
    else
    imagS21(y)=S21(i);
    y=y+1;
    end
end
outarray(:,4)=realS21;
outarray(:,5)=imagS21;

%�ֱ���ȡS12��ʵ�����鲿
x=1;y=1;
for i=1:length(S12)
    if rem(i,2)
    realS12(x)=S12(i);
    x=x+1;
    else
    imagS12(y)=S12(i);
    y=y+1;
    end
end
outarray(:,6)=realS12;
outarray(:,7)=imagS12;

%�ֱ���ȡS22��ʵ�����鲿
x=1;y=1;
for i=1:length(S22)
    if rem(i,2)
    realS22(x)=S22(i);
    x=x+1;
    else
    imagS22(y)=S22(i);
    y=y+1;
    end
end
outarray(:,8)=realS22;
outarray(:,9)=imagS22;

%�����ݴ�ӡ��TXT�ļ�
line1=firststr();
line2=secondstr();
line3=('!Data & Calibration Information:');
line4=sprintf('!Freq\tS11:NONE(--)\tS21:NONE(--)\tS12:NONE(--)\tS22:NONE(--)');
line5=('# Hz S RI R 50');
fp=fopen('SPAR.s2p','w');
fprintf(fp,'%s\r\n',line1);
fprintf(fp,'%s\r\n',line2);
fprintf(fp,'%s\r\n',line3);
fprintf(fp,'%s\r\n',line4);
fprintf(fp,'%s\r\n',line5);
fprintf(fp,'%.3f\t%.6e\t%.6d\t%.6e\t%.6e\t%.6e\t%.6e\t%.6e\t%.6e\r\n',outarray');
fclose(fp);

