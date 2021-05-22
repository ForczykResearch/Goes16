function PlotWindSpeedVsLocation(titlestr,figstr)
% This routine will plot the wind speed and direction over a geographic
% area in the form of a quiver plot
% Written By: Stephen Forczyk
% Created: Nov 11,2020
% Revised: -----
% Classification: Unclassified
global WindData MetaDataS MeanWindSpeedS;
global GOESFileName;

global vert1 hor1 widd lend;
global vert2 hor2 lend2 machine;
global chart_timel
global Fz1 Fz2 chart_time;
global idirector igrid;
global matpath moviepath mappath;
global jpegpath powerpath;
global ipowerpoint PowerPointFile scaling stretching padding;

initialtimestr=datestr(now);
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
meanwindspeed=MeanWindSpeedS.values;
eval(['cd ' mappath(1:length(mappath)-1)]);
load('USAHiResBoundaries.mat');
load('MexicoBoundaries.mat');
% map=colormap('jet');
% numjet=length(map);
% Now plot the Wind Data as a Quiver plot
movie_figure1=figure('position',[hor1 vert1 widd lend]);
%set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
set(gca,'XLim',[xmin xmax]);
set(gca,'YLim',[ymin ymax]);
x=WindData(:,2);
y=WindData(:,1);
u=WindData(:,5);
v=WindData(:,6);
direction=WindData(:,4);
h=quiver(x,y,u,v);
hold on
plot(USALon,USALat,'k');
plot(MexicoLon,MexicoLat,'k');
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
% newaxesh=axes('Position',[0 0 1 1]);
% set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
% tx1=.10;
% ty1=.10;
% txtstr1=levelstr
% txt1=text(tx1,ty1,levelstr,'FontWeight','bold','FontSize',10,'Color',...
%[1 0 0]);
pause(chart_time);
% Save this chart
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
close('all');
dispstr=strcat('Saved file-',figstr);
disp(dispstr);

end

