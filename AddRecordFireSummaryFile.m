function  AddRecordFireSummaryFile()
% This will add a record to the fire SummaryFile
% Written By: Stephen Forczyk
% Created: Oct 7,2020
% Revised:-----
% Classification: Unclassified
global GOESFileName FireDetails FireLabels
global FireSummaryFile FireSummaryData summarypath ;

PreviousFiles=cell(1,1);
% FireSummaryData{1,1}='Source File';
% FireSummaryData{1,2}='Start Scan Year';
% FireSummaryData{1,3}='Start Scan Day';
% FireSummaryData{1,4}='Start Scan Hour';
% FireSummaryData{1,5}='Start Scan Minute';
% FireSummaryData{1,6}='Fire Details';
% First load this file
eval(['cd ' summarypath(1:length(summarypath)-1)]);
load(FireSummaryFile);
[nrecp1,ncols]=size(FireSummaryData);
nrec=nrecp1-1;
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
if(nrec==0)
    nrec=nrec+1;
    FireSummaryData{1+nrec,1}=GOESFileName;
    FireSummaryData{1+nrec,2}=YearS;
    FireSummaryData{1+nrec,3}=DayS;
    FireSummaryData{1+nrec,4}=HourS;
    FireSummaryData{1+nrec,5}=MinuteS;
    FireSummaryData{1+nrec,6}=FireDetails; 
    actionstr='save';
    varstr='FireSummaryData';
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,FireSummaryFile,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Added Record-',num2str(nrec),'-To Matlab File-',FireSummaryFile);
    disp(dispstr);
    ab=1;
else % Check to see if this a duplicate entry
    for n=2:nrecp1
        PreviousFiles{n-1,1}=FireSummaryData{n,1};
    end
    imatch=0;
    for n=1:nrecp1-1
       prevFile=char(PreviousFiles{n,1});
       a1=strcmp(prevFile,GOESFileName);
       imatch=imatch+a1;
    end
% if no matches are found then add this and save-if this is a duplicate do
% nothing
    if(imatch==0)
        nrec=nrec+1;
        FireSummaryData{1+nrec,1}=GOESFileName;
        FireSummaryData{1+nrec,2}=YearS;
        FireSummaryData{1+nrec,3}=DayS;
        FireSummaryData{1+nrec,4}=HourS;
        FireSummaryData{1+nrec,5}=MinuteS;
        FireSummaryData{1+nrec,6}=FireDetails; 
        actionstr='save';
        varstr='FireSummaryData';
        qualstr='-v7.3';
        [cmdString]=MyStrcatV73(actionstr,FireSummaryFile,varstr,qualstr);
        eval(cmdString)
        dispstr=strcat('Added Record-',num2str(nrec),'-To Matlab File-',FireSummaryFile);
        disp(dispstr);
    else
        dispstr=strcat('No Record Added To Matlab File-',FireSummaryFile,'-Duplicate Record');
        disp(dispstr);
    end
end

end

