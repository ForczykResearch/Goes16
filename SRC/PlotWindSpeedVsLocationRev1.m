function PlotWindSpeedVsLocationRev1(HurricaneLonEst,HurricaneLatEst,titlestr,figstr)
% This routine will plot the wind speed and direction over a geographic
% area in the form of a quiver plot-Rev 1 version plots data according to 
% wind wind quadrant
% Written By: Stephen Forczyk
% Created: Nov 11,2020
% Revised: Jan 17,2021 added logic to include chart in PDF report
%          and a legend to indicate wind direction
% Revised: Jan 18,2021 pulled in data on measurment region Temp and
% Pressure
% Revised: Jan 19,2021 added in addition data regarding target selection
%          and sensor time between images
% Classification: Unclassified
global WindData MetaDataS MeanWindSpeedS;
global WindSpeedS Band_IDS Band_WavelengthS;
global numquad1 numquad2 numquad3 numquad4;
global GOESFileName;
global latS lonS timeS SecBetwnImagesS TimeBoundsS;
global TargetTypeS TargetBoxS;
global orange bubblegum brown brightblue;
global NumProcFiles ProcFileList;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global PressureS TempS GOESProjS;
global vert1 hor1 widd lend;
global vert2 hor2 lend2 machine;
global chart_timel
global Fz1 Fz2 chart_time;

global idirector igrid fid;
global matpath moviepath mappath;
global jpegpath powerpath;
global ipowerpoint PowerPointFile scaling stretching padding;
if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end
fprintf(fid,'\n');
fprintf(fid,'%s\n','---------- Starting WindSpeedPlot---------');
orange=[.9765 .4510 .0235];
bubblegum=[1 .4235 .7098];
brown=[.396 .263 .129];
brightblue=[.0039 .3961 .9882];
initialtimestr=datestr(now);
% Get some basic data
BandNum=Band_IDS.values;
BandCentWave=Band_WavelengthS.values;
TBI=SecBetwnImagesS.values;
bandstr1=strcat('Derived wind data computed using band#',num2str(BandNum),...
    '-which has a center wavelength of-',num2str(BandCentWave,2),'-microns. The actual time between images=',num2str(TBI),'-sec.');
fprintf(fid,'%s\n',bandstr1);
tgttype=TargetTypeS.values;
if(tgttype==0)
    tgttypestr1='For this time period, motion is determined from clear sky moisture gradients.';
else
    tgttypestr1='For this time period, motion is determined from actual cloud motions.';
end
fprintf(fid,'%s\n',tgttypestr1);
tgtboxsize=TargetBoxS.values;
tgttypestr2=strcat('The box size for locating targets is set to-',num2str(tgtboxsize),'-pixels.');
fprintf(fid,'%s\n',tgttypestr2);
% Set the plot limits
xmin1=min(WindData(:,2));
xmax1=max(WindData(:,2));
ymin1=min(WindData(:,1));
ymax1=max(WindData(:,1));
xmin=floor(xmin1);
xmax=ceil(xmax1);
ymin=floor(ymin1);
ymax=ceil(ymax1);
numpts=length(WindData(:,2));
% Find the median winds
[valid_range]=WindSpeedS.valid_range;
minvalidWS=valid_range(1,1);
maxvalidWS=valid_range(1,2);
minwindspeed=min(WindData(:,3));
meanwindspeed=mean(WindData(:,3));
maxwindspeed=max(WindData(:,3));
windstr10=strcat('The valid range of windspeeds is-',num2str(minvalidWS,5),'-to-',num2str(maxvalidWS,5),'-in mps.');
windstr11=strcat('The min measured windspeed was-',num2str(minwindspeed,5),'-the mean value-',num2str(meanwindspeed,5),...
    '-with a max measured speed of-',num2str(maxwindspeed,5),'-in m/s.');
windstr1=strcat('Number of Wind Measurements-',num2str(numpts),'.');
fprintf(fid,'%s\n',windstr1);
windstr2=strcat('Mean windspeed=',num2str(meanwindspeed),'-m/s');
fprintf(fid,'%s\n',windstr2);
% Get data on Temperatures and Pressures of measurment regions
TempData1=TempS.values;
PressureData1=PressureS.values;
% Get just the valid data for the temperatures
[valid_range]=TempS.valid_range;
TempLowLimit=valid_range(1,1);
TempHighLimit=valid_range(1,2);
SortedTemps=sort(TempData1);
numlowTemps=0;
numhighTemps=0;
numgoodTemps=0;
numtemps=length(SortedTemps);
for kk=1:numtemps
   if(SortedTemps(kk,1)<TempLowLimit)
       SortedTemps(kk,1)=TempLowLimit;
       numlowTemps=numlowTemps+1;
   elseif(SortedTemps(kk,1)>TempHighLimit)
       SortedTemps(kk,1)=TempHighLimit;
       numhighTemps=numhighTemps+1;
   else
       numgoodTemps=numgoodTemps+1;
   end
end
minTemp=min(SortedTemps);
meanTemp=mean(SortedTemps);
maxTemp=max(SortedTemps);
tempstr1=strcat('Valid Cloud Top Temp Range=',num2str(TempLowLimit,4),'-to-',num2str(TempHighLimit,4),'-Deg-k');
fprintf(fid,'%s\n',tempstr1);
tempstr2=strcat('Total Temp estimates=',num2str(numtemps),'-num valid temp estimates=',num2str(numgoodTemps),...
    '-num estimates out of range low=',num2str(numlowTemps),'-num estimates out of range high=',num2str(numhighTemps));
fprintf(fid,'%s\n',tempstr2);
tempstr3=strcat('Minimum valid Temp=',num2str(minTemp,5),'-Mean valid Temp=',num2str(meanTemp,5),...
    '-Max valid Temp=',num2str(maxTemp,5),'-in Deg-K');
fprintf(fid,'%s\n',tempstr3);
% Get the Valid Cloud Top Pressure readings
[valid_range]=PressureS.valid_range;
PressLowLimit=valid_range(1,1);
PressHighLimit=valid_range(1,2);
SortedPressure=sort(PressureData1);
numlowPress=0;
numhighPress=0;
numgoodPress=0;
numpress=length(SortedPressure);
for kk=1:numpress
   if(SortedPressure(kk,1)<PressLowLimit)
       SortedPressure(kk,1)=PressLowLimit;
       numlowPress=numlowPress+1;
   elseif(SortedPressure(kk,1)>PressHighLimit)
       SortedPressure(kk,1)=PressHighLimit;
       numhighPress=numhighPress+1;
   else
       numgoodPress=numgoodPress+1;
   end
end
minPres=min(SortedPressure);
meanPres=mean(SortedPressure);
maxPres=max(SortedPressure);
presstr1=strcat('Valid Cloud Top Pressure Range=',num2str(PressLowLimit,4),'-to-',num2str(PressHighLimit,4),'-mBar');
fprintf(fid,'%s\n',presstr1);
presstr2=strcat('Total Pressure estimates=',num2str(numpress),'-num valid pres estimates=',num2str(numgoodPress),...
    '-num estimates out of range low=',num2str(numlowPress),'-num estimates out of range high=',num2str(numhighPress));
fprintf(fid,'%s\n',presstr2);
presstr3=strcat('Minimum valid Pres=',num2str(minPres,5),'-Mean valid Pres=',num2str(meanPres,5),...
    '-Max valid Pres=',num2str(maxPres,5),'-in mBar');
fprintf(fid,'%s\n',presstr3);
eval(['cd ' mappath(1:length(mappath)-1)]);
load('USAHiResBoundaries.mat');
load('MexicoBoundaries.mat');
% first divide up the data into wind quadrants
direction=WindData(:,4);
% Get the quadrant 1 data (0 -90 deg)
[iquad1]=find(direction>=0 & direction<90);
[iquad2]=find(direction>=90 & direction<180);
[iquad3]=find(direction>=180 & direction<270);
[iquad4]=find(direction>=270 & direction<360);
numquad1=length(iquad1);
numquad2=length(iquad2);
numquad3=length(iquad3);
numquad4=length(iquad4);
windstr3=strcat('number of pts in quad 1 (0-90 deg)=',num2str(numquad1));
windstr4=strcat('number of pts in quad 2 (90-180 deg)=',num2str(numquad2));
windstr5=strcat('number of pts in quad 3 (180-270 deg)=',num2str(numquad3));
windstr6=strcat('number of pts in quad 34(270-360 deg)=',num2str(numquad4));
fprintf(fid,'%s\n',windstr3);
fprintf(fid,'%s\n',windstr4);
fprintf(fid,'%s\n',windstr5);
fprintf(fid,'%s\n',windstr6);
if(numquad1>0)
    x1=WindData(iquad1,2);
    y1=WindData(iquad1,1);
    u1=WindData(iquad1,5);
    v1=WindData(iquad1,6);
end
if(numquad2>0)
    x2=WindData(iquad2,2);
    y2=WindData(iquad2,1);
    u2=WindData(iquad2,5);
    v2=WindData(iquad2,6);
end
if(numquad3>0)
    x3=WindData(iquad3,2);
    y3=WindData(iquad3,1);
    u3=WindData(iquad3,5);
    v3=WindData(iquad3,6);
end
if(numquad4>0)
    x4=WindData(iquad4,2);
    y4=WindData(iquad4,1);
    u4=WindData(iquad4,5);
    v4=WindData(iquad4,6);
end
% Now plot the Wind Data as a Quiver plot
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.12 .18 .70 .70]);
set(gca,'XLim',[xmin xmax]);
set(gca,'YLim',[ymin ymax]);
hold on
% plot the quadrant 1
if(numquad1>0)
    q1=quiver(x1,y1,u1,v1);
    q1.Color='red';
end
if(numquad2>0)% orange
    q2=quiver(x2,y2,u2,v2);
    q2.Color=[.9765 .4510 .0235];
end
if(numquad3>0)
    q3=quiver(x3,y3,u3,v3);
    q3.Color='green';
end
if(numquad4>0)
    q4=quiver(x4,y4,u4,v4);
    q4.Color=[.0039 .3961 .9882];
end
plot(USALon,USALat,'k');
plot(MexicoLon,MexicoLat,'k');
% Plot the estimated hurricane center if it was calculated
test=HurricaneLonEst*HurricaneLatEst;
if(abs(test)>0)
    boxlat=[HurricaneLatEst-1 HurricaneLatEst-1 HurricaneLatEst+1 HurricaneLatEst+1 HurricaneLatEst-1];
    boxlon=[HurricaneLonEst-1 HurricaneLonEst+1 HurricaneLonEst+1 HurricaneLonEst-1 HurricaneLonEst-1];
    plot(HurricaneLonEst,HurricaneLatEst,'gh','MarkerSize',14,...
    'MarkerEdgeColor','g',...
    'MarkerFaceColor','y');
    plot(boxlon,boxlat,'r','LineWidth',2);
end
xlabel('Lon','FontWeight','bold');
ylabel('Lat','FontWeight','bold');
set(gca,'XLim',[xmin xmax]);
set(gca,'YLim',[ymin ymax]);
set(gca,'FontWeight','bold');
hold off
igrid=1;
if(igrid==1)
    set(gca,'XGrid','On','YGrid','On');
end
ht=title(titlestr);
set(ht,'FontWeight','bold');
% Set up the axis for writing at the bottom of the chart
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.10;
ty1=.10;
txtstr1=strcat('Crude Eye Position Lat=',num2str(HurricaneLatEst),'-Lon=',...
    num2str(HurricaneLonEst));
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',10,'Color',[1 0 0]);
% Add 4 patches to the figure to show wind direction
x11 = [0.84 0.85 0.85 0.84];
y11 = [0.82 0.82 0.83 0.83];
patch(x11,y11,'red')
tx11=0.855;
ty11=0.825;
txtstr11='Wind Dir 0-90 Deg';
txt11=text(tx11,ty11,txtstr11,'FontWeight','bold','FontSize',10,'Color',[1 0 0]);
x12 = [0.84 0.85 0.85 0.84];
y12 = [0.78 0.78 0.79 0.79];
patch(x12,y12,[.9765 .4510 .0235])
tx12=0.855;
ty12=0.785;
txtstr12='Wind Dir 90-180 Deg';
txt12=text(tx12,ty12,txtstr12,'FontWeight','bold','FontSize',10,'Color',[.9765 .4510 .0235]);
x13 = [0.84 0.85 0.85 0.84];
y13 = [0.74 0.74 0.75 0.75];
patch(x13,y13,'green')
tx13=0.855;
ty13=0.745;
txtstr13='Wind Dir 180-270 Deg';
txt13=text(tx13,ty13,txtstr13,'FontWeight','bold','FontSize',10,'Color',[0 1 0]);
x14 = [0.84 0.85 0.85 0.84];
y14 = [0.70 0.70 0.71 0.71];
patch(x14,y14,[.0039 .3961 .9882])
tx14=0.855;
ty14=0.705;
txtstr14='Wind Dir 270-360 Deg';
txt14=text(tx14,ty14,txtstr14,'FontWeight','bold','FontSize',10,'Color',[.0039 .3961 .9882]);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    headingstr1=strcat('Dervived Motion Winds For-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    add(chapter,Section('Wind Magnitude Direction Map'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Wind Data For File-',GOESShortFileName);
    pdftext = Text(pdftxtstr);
    pdftext.Color = 'red';
    image.Caption = pdftext;
    nhighs=floor(nhigh/2.2);
    nwids=floor(nwid/2.2);
    heightstr=strcat(num2str(nhighs),'px');
    widthstr=strcat(num2str(nwids),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
% Now add some text 
    parastr1=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr2=strcat('This metric is created using data taken from the ABI sensor and run through a complex algorithm to produce the wind speed estimate.');
    parastr3='The algorithm can estimate not only the speed and direction of the winds, but also their altitude.';
    parastr4='The process employs the use of 3 consecutive images typically taken 5 minutes apart.';
    parastr5=strcat('In order to detect the winds clouds or moisture gradients must be identified and tracked.',...
        'Note that valid measurements must be combined with a tracking algorithim to produce valid wind speed ESTIMATES.');
    parastr6=strcat(parastr1,parastr2,parastr3,parastr4,parastr5,tgttypestr1,tgttypestr2);
    p1 = Paragraph(parastr6);
    p1.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p1);
    parastr10='Since Wind velocity is a vector quantity, a quiver plot was chosen to plot both the wind speed and direction.';
    parastr11='Wind velocities are calculated at points where a distinct feature such as a cloud could be tracked for 3 consecutive frames.';
    parastr12='The location of the wind corresponds to the base of the arrow,the length and orientation of the arrow depicts the direction .';
    parastr13='Some scenes generate many velocity estimates and in this case the individual arrows are hard to spot-';
    parastr14='for this reason, each arrow is colored according to which quadrant the  arrow is pointing-see the legend at the upper left of the chart.';
    parastr15=strcat(parastr10,parastr11,parastr12,parastr13,parastr14);
    p2 = Paragraph(parastr15);
    p2.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    parastr20=strcat('The total number of Wind estimates were-',num2str(numpts),'-while the number of estimates in quadrant 1=',num2str(numquad1),'.');
    parastr21=strcat('The estimates for quad 2,3 and 4 were-quad2=',num2str(numquad2),'-quad3=',num2str(numquad3),'-and quad4=',num2str(numquad4),'-respectively.');
    parastr24=strcat(parastr20,parastr21);
    p3 = Paragraph(parastr24);
    p3.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p3);
    parastr29=strcat(bandstr1,windstr1,windstr10,windstr11);
    p5 = Paragraph(parastr29);
    p5.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p5);
    parastr30='An experimental feature has been added to the chart-namely an initial attemp to location hurricane centers.';
    parastr31='This is still very much a work in progress. The basic idea is to locate a region where a given point is surrounded by a significant';
    parastr32=' number of wind velocity estimates in all 4 qudrants. The selected point is designated by a yellow hexagon.';
    parastr34=strcat(parastr30,parastr31,parastr32);
    p4 = Paragraph(parastr34);
    p4.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p4);
close('all');
dispstr=strcat('Saved file-',figstr);
disp(dispstr);
fprintf(fid,'%s\n','-------- Finished WindSpeedPlot--------');
fprintf(fid,'\n');
end

