function CreateFireSummaryFile()
% Create A Fire SummaryFile to hold previous fire detections
% Written By: Stephen Forczyk
% Created: Oct 7,2020
% Revised:-----
% Classification:Unclassified
global FireSummaryFile FireSummaryData summarypath ;

FireSummaryData=cell(1,1);
FireSummaryData{1,1}='Source File';
FireSummaryData{1,2}='Start Scan Year';
FireSummaryData{1,3}='Start Scan Day';
FireSummaryData{1,4}='Start Scan Hour';
FireSummaryData{1,5}='Start Scan Minute';
FireSummaryData{1,6}='Fire Details';
actionstr='save';
varstr='FireSummaryData';
qualstr='-v7.3';
[cmdString]=MyStrcatV73(actionstr,FireSummaryFile,varstr,qualstr);
eval(cmdString)
dispstr=strcat('Created Matlab File-',FireSummaryFile);
disp(dispstr);

end

