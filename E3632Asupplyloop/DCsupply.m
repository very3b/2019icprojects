clear all;

% 代码所控制的仪器类型：agilent公司E3632A型号的直流电源
%使用GPIB驱动“NI MAX”识别到电源设备后，打开“IO Control”再次扫描到GPIB端口设备。
%获得“GPIB0::7::INSTR”这样的地址，在visaObj中可以看到Status是open的状态即可工作。

oldObjects=instrfind;
if ~isempty(oldObjects)
    delete(oldObjects);
    clear oldObjects;
end
resourceStruct = instrhwinfo('visa','agilent'); 
visaObj=visa('agilent', 'GPIB0::7::INSTR');% 
%% 配置接口参数
% 设定输入缓冲区来存储读取的数据
set(visaObj, 'InputBufferSize', 20000);
% 设定timeout参数，保证仪器有足够的时间反应
set(visaObj, 'Timeout', 10);
%连接到仪器
fopen(visaObj);


fprintf(visaObj, '*CLS');%清除状态
fprintf(visaObj, '*OPC');%询问上一操作是否完成
    

P15V=input('请输入端口电压的范围:','s');%输入格式为“0.1~15”或者“0.1~30”
[P15Vmin,P15Vmax]=inputdefine(P15V);
Sp=input('请输入步进:');
P15Vvec=[P15Vmin:Sp:P15Vmax];

for i=1:length(P15Vvec)%开始循环
P15Vstr=['APPL ' num2str(P15Vvec(i)) ',2.0'] 
fprintf(visaObj, P15Vstr);%设置输出端口的输出电压为
fprintf(visaObj, '*OPC');

fprintf(visaObj, 'OUTP:STAT ON');%开启输出端口


VP15V(i)=str2num(query(visaObj,'MEAS:VOLT:DC? P15V')) %测量+30V端口的输出电压值
C(i)=str2num(query(visaObj,'MEAS:CURR:DC? P15V')) %测量30V端口的输出电流值

end
 %作图
plot(VP15V,C);
xlabel('Vds')
ylabel('Ids')
grid on
hold on;