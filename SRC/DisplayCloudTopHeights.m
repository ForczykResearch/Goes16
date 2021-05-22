function  DisplayCloudTopHeights(titlestr)
% Display the cloud top heights from the GOES16/17 data
% Written By: Stephen Forczyk
% Created: August 2,2020
% Revised: -----
% Classification: Unclassified
global BandDataS MetaDataS;
global CMIS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global HTS DQF1S OutlierPS CloudTopS Algo1S ProcessParamS;
global LZAS LZABS SZAS SZABS Error1S CloudPixelsS;
global GOESFileName HTS;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath ;
global smhrpath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
% additional paths needed for mapping
global matpath1 mappath;
global canadapath stateshapepath topopath;
global trajpath militarypath;
global figpath screencapturepath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;

% Now plot the Cloud Top Heigts as an Image
minval=0;
HT=HTS.values;
maxval=max(max(HT));
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','None');
set(gca,'Position',[.16 .18 .60 .70]);
set(gca,'YDir','normal');
hl=imagesc(HT,[minval maxval]);colormap(jet);
set(gca,'YDir','normal');
hb=colorbar;
set(gca,'FontWeight','bold');
xlabel('X Pixel','FontWeight','bold');
ylabel('Y Pixel','FontWeight','bold');
ht=title(titlestr);
set(ht,'FontWeight','bold');
% Set up an axis for writing text at the bottom of the chart
% newaxesh=axes('Position',[0 0 1 1]);
% set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
% tx1=.10;
% ty1=.08;
% txtstr1=strcat('Chart Creation Date-',initialtimestr);
% txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',8);
% tx2=.45;
% ty2=.04;
% txtstr2=levelstr;
% txt2=text(tx2,ty2,levelstr,'FontWeight','bold','FontSize',10,'Color',[1 0 0]);
% tx3=.45;
% ty3=.95;
% txtstr3=levelstr;
% txt3=text(tx3,ty3,levelstr,'FontWeight','bold','FontSize',10,'Color',[1 0 0]);
% tx4=.10;
% ty4=.07;
% wlow=WL(iband,1);
% whigh=WL(iband,2);
% txtstr4=strcat('Selected Roll Angle-',num2str(SelectedRollAngle,5),'-bandlow=',...
%     num2str(wlow,6),'-to-',num2str(whigh,5));
% txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',8);
%set(newaxesh,'Visible','Off');
% Save this chart
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
pause(chart_time);
close('all');
end

