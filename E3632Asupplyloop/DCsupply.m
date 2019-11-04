clear all;

% ���������Ƶ��������ͣ�agilent��˾E3632A�ͺŵ�ֱ����Դ
%ʹ��GPIB������NI MAX��ʶ�𵽵�Դ�豸�󣬴򿪡�IO Control���ٴ�ɨ�赽GPIB�˿��豸��
%��á�GPIB0::7::INSTR�������ĵ�ַ����visaObj�п��Կ���Status��open��״̬���ɹ�����

oldObjects=instrfind;
if ~isempty(oldObjects)
    delete(oldObjects);
    clear oldObjects;
end
resourceStruct = instrhwinfo('visa','agilent'); 
visaObj=visa('agilent', 'GPIB0::7::INSTR');% 
%% ���ýӿڲ���
% �趨���뻺�������洢��ȡ������
set(visaObj, 'InputBufferSize', 20000);
% �趨timeout��������֤�������㹻��ʱ�䷴Ӧ
set(visaObj, 'Timeout', 10);
%���ӵ�����
fopen(visaObj);


fprintf(visaObj, '*CLS');%���״̬
fprintf(visaObj, '*OPC');%ѯ����һ�����Ƿ����
    

P15V=input('������˿ڵ�ѹ�ķ�Χ:','s');%�����ʽΪ��0.1~15�����ߡ�0.1~30��
[P15Vmin,P15Vmax]=inputdefine(P15V);
Sp=input('�����벽��:');
P15Vvec=[P15Vmin:Sp:P15Vmax];

for i=1:length(P15Vvec)%��ʼѭ��
P15Vstr=['APPL ' num2str(P15Vvec(i)) ',2.0'] 
fprintf(visaObj, P15Vstr);%��������˿ڵ������ѹΪ
fprintf(visaObj, '*OPC');

fprintf(visaObj, 'OUTP:STAT ON');%��������˿�


VP15V(i)=str2num(query(visaObj,'MEAS:VOLT:DC? P15V')) %����+30V�˿ڵ������ѹֵ
C(i)=str2num(query(visaObj,'MEAS:CURR:DC? P15V')) %����30V�˿ڵ��������ֵ

end
 %��ͼ
plot(VP15V,C);
xlabel('Vds')
ylabel('Ids')
grid on
hold on;