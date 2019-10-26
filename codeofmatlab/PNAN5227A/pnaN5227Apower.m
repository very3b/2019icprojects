% Connected to: Agilent Technologies,N5227A
% Define instrument VISA address. The VISA address of the instrument
% may be obtained from the instrument's user interface or your VISA
% configuration utility
% Define frequency range of 2.3GHz to 2.6GHz
% Define instrument VISA address. The VISA address of the instrument
% may be obtained from the instrument's user interface or your VISA
% configuration utility
% Define frequency range of 2.3GHz to 2.6GHz
frequencyRange = [2e9 9e9];
% Number of points in measurement
numPoints = 1001;
% Define the loop of Power Level in every S parameter measurement

PSTART=-10;% Define the start value of Power sweep
PSTOP=0;% Define the stop value of Power sweep
PSTEP=1;% Define the step value of Power sweep
for powerlevel=PSTART:PSTEP:PSTOP 

% Create a VISA connection to interface with instrument

oldObjects=instrfind;
if ~isempty(oldObjects)
    delete(oldObjects);
    clear oldObjects;
end
resourceStruct = instrhwinfo('visa','agilent'); 

visaObj=visa('agilent', 'TCPIP0::192.168.2.11::inst0::INSTR');
set(visaObj, 'InputBufferSize', 10e6);
set(visaObj, 'Timeout', 30);
fopen(visaObj);


% Display information about instrument
IDNString = query(visaObj,'*IDN?');
fprintf('Connected to: %s\n',IDNString);

% Wait till system is ready as Preset could take time
%opcStatus = 0;
%while(~opcStatus)
%    opcStatus = str2double(query(instrObj, '*OPC?'));
%end

% Define a measurement name and parameter
fprintf(visaObj,'CALCulate:PARameter:DEFine:EXT ''SParamMeasurementS11'',S11');
fprintf(visaObj,'CALCulate:PARameter:DEFine:EXT ''SParamMeasurementS12'',S12');
fprintf(visaObj,'CALCulate:PARameter:DEFine:EXT ''SParamMeasurementS21'',S21');
fprintf(visaObj,'CALCulate:PARameter:DEFine:EXT ''SParamMeasurementS22'',S22');

% Create a new display window and turn it on
fprintf(visaObj,'DISPlay:WINDow1:STATE ON');

% Associate the measurements to WINDow1
fprintf(visaObj,'DISPlay:WINDow1:TRACe1:FEED ''SParamMeasurementS11''');
fprintf(visaObj,'DISPlay:WINDow1:TRACe2:FEED ''SParamMeasurementS12''');
fprintf(visaObj,'DISPlay:WINDow1:TRACe3:FEED ''SParamMeasurementS21''');
fprintf(visaObj,'DISPlay:WINDow1:TRACe4:FEED ''SParamMeasurementS22''');

% Turn ON the Title, Frequency, and Trace Annotation to allow for
% visualization of the measurements on the instrument display
fprintf(visaObj,'DISPlay:WINDow1:TITLe:STATe ON');
fprintf(visaObj,'DISPlay:ANNotation:FREQuency ON');
fprintf(visaObj,'DISPlay:WINDow1:TRACe1:STATe ON');
fprintf(visaObj,'DISPlay:WINDow1:TRACe2:STATe ON');
fprintf(visaObj,'DISPlay:WINDow1:TRACe3:STATe ON');
fprintf(visaObj,'DISPlay:WINDow1:TRACe4:STATe ON');

% Turn OFF averaging
fprintf(visaObj,'SENSe1:AVERage:STATe OFF');

% Set the power level
fprintf(visaObj, sprintf('SOURce:POWer %s',num2str(powerlevel)));

% Set the number of points
fprintf(visaObj, sprintf('SENSe:SWEep:POINts %s',num2str(numPoints)));

% Set the frequency ranges
fprintf(visaObj, sprintf('SENSe:FREQuency:STARt %sHz',num2str(frequencyRange(1))));
fprintf(visaObj, sprintf('SENSe:FREQuency:STOP %sHz',num2str(frequencyRange(2))));

% Select measurements and set measurement trigger to immediate
fprintf(visaObj,'CALCulate:PARameter:SELect ''SParamMeasurementS11''');
fprintf(visaObj,'CALCulate:PARameter:SELect ''SParamMeasurementS12''');
fprintf(visaObj,'CALCulate:PARameter:SELect ''SParamMeasurementS21''');
fprintf(visaObj,'CALCulate:PARameter:SELect ''SParamMeasurementS22''');
fprintf(visaObj,'TRIG:SOURce IMMediate');

% Autoscale display
fprintf(visaObj, 'DISPlay:WIND:Y:AUTO');

% Select a single sweep across the frequency range to trigger a measurement
fprintf(visaObj,':SENSe:SWEep:MODE SINGLE');

% Since the instrument may take time to make the measurement, wait until it
% is done before requesting measurement data
opcStatus = 0;
while(~opcStatus)
    opcStatus = str2double(query(visaObj, '*OPC?'));
end

% Set instrument to return the data back using binblock format
fprintf(visaObj, 'FORMat REAL,64');

% Set byte order to swapped (little-endian) format. SWAPped is required
% when using IBM compatible computers
fprintf(visaObj, 'FORMat:BORDer SWAP');

% Request 2-port measurement data from instrument
fprintf(visaObj, 'CALC:DATA:SNP:PORTs? ''1,2''');

% Read the measured data
rawDataDB = binblockread(visaObj, 'double'); 
fread(visaObj,1);

% Read back the number of points in the measurement and reshape the
% measurement data
numPoints = str2double(query(visaObj,' SENSe:SWEep:POINts?'));
% Reshape measurement data to [frequency, real, imag] array
rawDataDB = reshape(rawDataDB, numPoints, 9);

% Close, delete, and clear instrument connections.
fclose(visaObj);
delete(visaObj);
clear visaObj;

% Store frequency range of the measurements
freqRange = rawDataDB(:,1);

% Convert retrieved magnitude info from dB
sparamMag = 10.^((1/20).*rawDataDB(:,2:2:8));

% Convert retrieved phase info from degrees to radians
sparamPhase = rawDataDB(:,3:2:9)*(pi/180);

% Extract S-Parameter vectors
rawDataRI = sparamMag.*(cos(sparamPhase)+1i*sin(sparamPhase));
S11 = reshape(rawDataRI(:,1),1,1,numPoints);
S12 = reshape(rawDataRI(:,3),1,1,numPoints);
S21 = reshape(rawDataRI(:,2),1,1,numPoints);
S22 = reshape(rawDataRI(:,4),1,1,numPoints);

% Assemble into a 3D matrix to be consumed by the RF Toolbox
SParameter3Ddata = [S11 S12; S21 S22];

%Name each s2p file by the power value 
rfwrite(SParameter3Ddata,freqRange,[num2str(powerlevel),'.s2p']);
%rfwrite(SParameter3Ddata,freqRange,'LNASParams.s2p');

% Create the sparameters object
hSParamData = sparameters(SParameter3Ddata,freqRange);
% Plot the magnitude v/s frequency plot for the S-parameters of the LNA in
% each power sweep 
figure
rfplot(hSParamData);
title(['Power = ',num2str(powerlevel),' dBm']);
end