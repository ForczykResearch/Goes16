function DisplayCMIDataRev2(titlestr,itype,bandnum)
% Display the CMI Moisture Data from the GOES16 data
% Derived from DisplayCMIData big change involves using gridded data to
% allow overlay of geographic boundaries. This is an updated version
% or the Rev1 file of the same name. The big difference is this version of
% the file will calculate an on the spot grid for the meso scale factor
% files. The reason is that the meo areas could change with time. The Full
% Disk and Conus form factor files tend to stare at the same spot
% Written By: Stephen Forczyk
% Created: Apr 12,2021
% Revised: ----

% Classification: Unclassified
% Notes: Band 1 mapping probably Okay
%        Band 2 mapping probably Okay
%        Band 3 mapping looks good
%        Band 4 mapping looks good
%        Band 5 mapping looks good
%        Band 6 mapping looks good
%        Band 7 mapping looks good
%        Band 8 mapping looks good
%        Band 9 mapping looks good
%        Band 10 mapping looks good
%        Band 11 mapping looks good
%        Band 12 mapping looks good
%        Band 13 mapping looks good
%        Band 14 mapping looks good
%        Band 15 mapping looks good
%        Band 16 mapping looks good

global BandDataS MetaDataS GoesWaveBand;
global CMIS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global HTS DQF1S OutlierPS CloudTopS Algo1S ProcessParamS;
global LZAS LZABS SZAS SZABS Error1S CloudPixelsS;
global GOESFileName MapFormFactor;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global westEdge eastEdge northEdge southEdge;
global NumProcFiles ProcFileList;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter tocc;
global JpegCounter JpegFileList;
global DQFHdr DQFTable MiscHdr MiscTable RqmtsHdr RqmtsTable;
global DQFCauses DQFNormed DQFLabels;
global MapFormFactor;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2 fid;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath ;
global smhrpath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
% additional paths needed for mapping
global matpath1 mappath;
global canadapath stateshapepath topopath;
global trajpath militarypath gridpath;
global figpath screencapturepath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;
persistent ncallsCMI;

if isempty(ncallsCMI)
    ncallsCMI=0;
end
ncallsCMI=ncallsCMI+1;
if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end

if(itype==1)
    fprintf(fid,'%s\n','------- Plot Cloud Moisture Data For Full Disk ------');
elseif(itype==2)
    fprintf(fid,'%s\n','------- Plot Cloud Moisture Data For Conus ------');
elseif(itype==3)
    fprintf(fid,'%s\n','------- Plot Cloud Moisture Data Meso Scale ------'); 
else
    
end
eval(['cd ' gridpath(1:length(gridpath)-1)]);
CMI=CMIS.values;
if(itype==1)
    GridMatFileName='CMIFullDiskGrid.mat';
elseif(itype==2)
    if(bandnum==1)
        GridMatFileName='ConusBand1CMILatLonGridRev2.mat';
    end
    if(bandnum==2)
        GridMatFileName='ConusBand2CMILatLonGrid.mat';
    end
    if(bandnum==3)
        GridMatFileName='ConusBand3CMILatLonGrid.mat';
    end
    if(bandnum==4)
        GridMatFileName='ConusBand4CMILatLonGrid.mat';
    end
    if(bandnum==5)
        GridMatFileName='ConusBand5CMILatLonGrid.mat';
    end
    if(bandnum==6)
        GridMatFileName='ConusBand6CMILatLonGrid.mat';
    end
    if(bandnum==7)
        GridMatFileName='ConusBand7CMILatLonGrid.mat';
    end
    if(bandnum==8)
        GridMatFileName='ConusBand8CMILatLonGrid.mat';
    end
    if(bandnum==9)
        GridMatFileName='ConusBand9CMILatLonGrid.mat';
    end
    if(bandnum==10)
        GridMatFileName='ConusBand10CMILatLonGrid.mat';
    end
    if(bandnum==11)
        GridMatFileName='ConusBand11CMILatLonGrid.mat';
    end
    if(bandnum==12)
        GridMatFileName='ConusBand12CMILatLonGrid.mat';
    end
    if(bandnum==13)
        GridMatFileName='ConusBand13CMILatLonGrid.mat';
    end
    if(bandnum==14)
        GridMatFileName='ConusBand14CMILatLonGrid.mat';
    end
    if(bandnum==15)
        GridMatFileName='ConusBand15CMILatLonGrid.mat';
    end
    if(bandnum==16)
        GridMatFileName='ConusBand16CMILatLonGrid.mat';
    end
elseif(itype==3)
    numrasterlon=length(xS.values);
    numrasterlat=length(yS.values);
    numvals=numrasterlon*numrasterlat;
    xx=xS.values;
    yy=yS.values;
    RasterLats=zeros(numrasterlon,numrasterlat);
    RasterLons=RasterLats;
    waitstr='Calculating Geographic Raster';
    h=waitbar(0,waitstr);
    tic;
    for jj=1:numrasterlat
        for kk=1:numrasterlon
            [GeodLat,GeodLon] = CalculateGeodCoordFromXYPosRev1(xx(kk,1),yy(jj,1));
            RasterLats(jj,kk)=GeodLat;
            RasterLons(jj,kk)=GeodLon;
        end
        waitbar(jj/numrasterlat);
    end
    close(h);
    elapsed_time=toc;
    dispstr=strcat('Calculating the Raster took-',num2str(elapsed_time,5),'-sec');
    disp(dispstr)
    GridMatFileName='ComputedInPlace';
end
[nrows,ncols]=size(CMI);
numcmipixels=nrows*ncols;
numgoodpixels=floor(numcmipixels*DQFS.percent_good_pixel_qf);
numbadpixels=floor(numcmipixels*DQFS.percent_out_of_range_pixel_qf);
% Find out how many pixels returned values
[igood,jgood]=find((CMI>0) & (CMI<1));
numuseable=length(igood);
if((itype==1)|| (itype==2))
    gridstr1=strcat('Will Load Map Grid From File=',GridMatFileName,'-for band-',num2str(bandnum));
    fprintf(fid,'%s\n',gridstr1);
    load(GridMatFileName,'RasterLats','RasterLons');
    dispstr=strcat('Loaded Grid Raster File-',GridMatFileName);
    disp(dispstr)
elseif(itype==3)
    gridstr1=strcat('Meso Scale Raster Calculated On The Fly-for band-',num2str(bandnum));
    fprintf(fid,'%s\n',gridstr1);
    gridstr2=strcat('This calculation took=',num2str(elapsed_time,5),'-sec');
    fprintf(fid,'%s\n',gridstr2);
end
% Retrieve some data about this waveband
bandnumstr=num2str(bandnum);
bandres=GoesWaveBand{1+bandnum,2};
bandwave=GoesWaveBand{1+bandnum,3};
bandspec=char(GoesWaveBand{1+bandnum,4});
banddesc=char(GoesWaveBand{1+bandnum,5});
bandstr1=strcat('CMI File is for waveband-',bandnumstr,'-wavelength=',num2str(bandwave,4),'-microns');
fprintf(fid,'%s\n',bandstr1);
bandstr2=strcat('resolution-km=',num2str(bandres),'-band specificiation-',bandspec,...
    '-band description=',banddesc);
fprintf(fid,'%s\n',bandstr2);
sizestr1=strcat('CMI grid has-',num2str(nrows),'-rows and-',num2str(ncols),...
    '-cols of data');
disp(sizestr1);
fprintf(fid,'%s\n',sizestr1);
% Get some stats on the moisture
CMI1D=reshape(CMI,nrows*ncols,1);
CMI1DS=sort(CMI1D);
maxCMI=max(CMI1D);
minCMI=min(CMI1D);
nvals=nrows*ncols;
num50=floor(.5*nvals);
num90=floor(.9*nvals);
num99=floor(.99*nvals);
val50=CMI1DS(num50,1);
val90=CMI1DS(num90,1);
val99=CMI1DS(num99,1);
statstr1=strcat('Min CMI value=',num2str(minCMI,6),'-Max CMI value=',num2str(maxCMI,6));
fprintf(fid,'%s\n',statstr1);
statstr2=strcat('Median CMI value=',num2str(val50,6),'//-90 pctile value=',num2str(val90,6),...
    '//-99 pctile value=',num2str(val99,6));
fprintf(fid,'%s\n',statstr2);
% Fetch the map limits
westEdge=double(GeoSpatialS.geospatial_westbound_longitude);
eastEdge=double(GeoSpatialS.geospatial_eastbound_longitude);
southEdge=double(GeoSpatialS.geospatial_southbound_latitude);
northEdge=double(GeoSpatialS.geospatial_northbound_latitude);
maplimitstr1='****Map Limits Follow*****';
fprintf(fid,'%s\n',maplimitstr1);
maplimitstr2=strcat('WestEdge=',num2str(westEdge,7),'-EastEdge=',num2str(eastEdge));
fprintf(fid,'%s\n',maplimitstr2);
maplimitstr3=strcat('SouthEdge=',num2str(southEdge,7),'-NorthEdge=',num2str(northEdge));
fprintf(fid,'%s\n',maplimitstr3);
maplimitstr4='****Map Limits End*****';
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
% Get the scan end date and time data based on the file name
[YearE,DayE,HourE,MinuteE,SecondE] = GetGOESDateTimeString(GOESFileName,2);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
datestr10='***** Scan Time Definition Follows *****';
datestr14='***** Scan Time Definition End *****';
fprintf(fid,'%s\n',datestr10);
datestr11=strcat('Year=',num2str(YearS,4),'-Day=',num2str(DayS,3),'-Hour=',num2str(HourS,2),...
    '-Minute=',num2str(MinuteS,2),'-Second=',num2str(SecondS,5));
fprintf(fid,'%s\n',datestr11);
datestr12=strcat('Calender Month and Day=',MonthDayStr);
fprintf(fid,'%s\n',datestr12);
fprintf(fid,'%s\n',datestr14);
% Set up the map axis
if(itype==1)
    axesm ('globe','Frame','on','Grid','on','meridianlabel','off','parallellabel','on',...
        'plabellocation',[-60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60],'mlabellocation',[]);
elseif(itype==2)
    axesm ('pcarree','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
     'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',10,'mlabellocation',10,...
     'MLabelParallel','south','Frame','on','FontColor','b');  
      gridm('GLineStyle','-','Gcolor',[.1 .1 .1],'Galtitude',.002,'MLineLocation',10,...
    'PLineLocation',10);
elseif(itype==3)
    axesm ('pcarree','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
     'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',10,'mlabellocation',20,...
     'MLabelParallel','south');
end
set(gcf,'MenuBar','none');
set(gcf,'Position',[hor1 vert1 widd lend])
geoshow(RasterLats',RasterLons',CMI-0.025,'DisplayType','texturemap');
demcmap(CMI'-0.025,256);
hold on
% load the country borders and plot them
eval(['cd ' mappath(1:length(mappath)-1)]);
load('USAHiResBoundaries.mat','USALat','USALon');
plotm(USALat,USALon,'r');
load('CanadaBoundaries.mat','CanadaLat','CanadaLon');
plotm(CanadaLat,CanadaLon,'r');
load('MexicoBoundaries.mat','MexicoLat','MexicoLon');
plotm(MexicoLat,MexicoLon,'r');
load('CubaBoundaries.mat','CubaLat','CubaLon');
plotm(CubaLat,CubaLon,'r');
load('DominicanRepublicBoundaries.mat','DRLat','DRLon');
plotm(DRLat,DRLon,'r');
load('HaitiBoundaries.mat','HaitiLat','HaitiLon');
plotm(HaitiLat,HaitiLon,'r');
load('BelizeBoundaries.mat','BelizeLat','BelizeLon');
plotm(BelizeLat,BelizeLon,'r');
load('GautemalaBoundaries.mat','GautemalaLat','GautemalaLon');
plotm(GautemalaLat,GautemalaLon,'r')
load('JamaicaBoundaries.mat','JamaicaLat','JamaicaLon');
plotm(JamaicaLat,JamaicaLon,'r');
load('NicaraguaBoundaries.mat','NicaraguaLat','NicaraguaLon');
plotm(NicaraguaLat,NicaraguaLon,'r')
load('HondurasBoundaries.mat','HondurasLat','HondurasLon');
plotm(HondurasLat,HondurasLon,'r')
load('ElSalvadorBoundaries.mat','ElSalvadorLat','ElSalvadorLon');
plotm(ElSalvadorLat,ElSalvadorLon,'r');
load('PanamaBoundaries.mat','PanamaLat','PanamaLon');
plotm(PanamaLat,PanamaLon,'r');
load('ColumbiaBoundaries.mat','ColumbiaLat','ColumbiaLon');
plotm(ColumbiaLat,ColumbiaLon,'r');
load('VenezuelaBoundaries.mat','VenezuelaLat','VenezuelaLon');
plotm(VenezuelaLat,VenezuelaLon,'r')
load('PeruBoundaries.mat','PeruLat','PeruLon');
plotm(PeruLat,PeruLon,'r');
load('EcuadorBoundaries.mat','EcuadorLat','EcuadorLon');
plotm(EcuadorLat,EcuadorLon,'r')
load('BrazilBoundaries.mat','BrazilLat','BrazilLon');
plotm(BrazilLat,BrazilLon,'r');
load('BoliviaBoundaries.mat','BoliviaLat','BoliviaLon');
plotm(BoliviaLat,BoliviaLon,'r')
load('ChileBoundaries.mat','ChileLat','ChileLon');
plotm(ChileLat,ChileLon,'r');
load('ArgentinaBoundaries.mat','ArgentinaLat','ArgentinaLon');
plotm(ArgentinaLat,ArgentinaLon,'r');
load('UruguayBoundaries.mat','UruguayLat','UruguayLon');
plotm(UruguayLat,UruguayLon,'r');
load('CostaRicaBoundaries.mat','CostaRicaLat','CostaRicaLon');
plotm(CostaRicaLat,CostaRicaLon,'r');
load('FrenchGuianaBoundaries.mat','FrenchGuianaLat','FrenchGuianaLon');
plotm(FrenchGuianaLat,FrenchGuianaLon,'r');
load('GuyanaBoundaries.mat','GuyanaLat','GuyanaLon');
plotm(GuyanaLat,GuyanaLon,'r');
load('SurinameBoundaries.mat','SurinameLat','SurinameLon');
plotm(SurinameLat,SurinameLon,'r');
title(titlestr)
hold off
tightmap;
hc=colorbar;
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
Pos=get(hc,'Position');
PosyL=.80*Pos(1,2);
PosyU=1.03*(Pos(1,2)+Pos(1,4));
tx1=.13;
ty1=PosyL;
tx2=tx1;
ty2=ty1-.04;
tx2=tx1;
ty2=ty1-.04;
txtstr2=strcat('Band-',bandnumstr,'-Res-km=',num2str(bandres),'-Wavelength=',num2str(bandwave),...
    '-Spectrum=',bandspec,'-Description=',banddesc,'-----',MonthDayYearStr);
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',12);
tx3=tx1;
ty3=ty2-.04;
txtstr3=strcat('Minimum Reflectance=',num2str(minCMI,6),'-Max Reflectance=',num2str(maxCMI,6));
txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',12);
tx4=.82;
ty4=PosyU+.02;
txt4=text(tx4,ty4,'CMI Reflectance','FontWeight','bold','FontSize',12);
tx5=tx1;
ty5=ty3-.04;
txtstr5='To enhance cloud visibility a value of 0.025 was subtracted from the CMI value';
txt5=text(tx5,ty5,txtstr5,'FontWeight','bold','FontSize',12);
set(newaxesh,'Visible','Off');
% Save this chart
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
pause(chart_time);
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    headingstr1=strcat('ABI CMI Output For File-',GOESShortFileName,'-band-',num2str(bandnum));
    chapter = Chapter("Title",headingstr1);
    sectionstr=strcat('ABI-CMI-',MapFormFactor,'-Band-',bandnumstr);
    add(chapter,Section(sectionstr));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Cloud CMI For File-',GOESShortFileName);
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
    parastr5='The Data for this chart was from file-';
    parastr6=strcat(parastr5,GOESFileName);
    p2 = Paragraph(parastr6);
    p2.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p2);
    parastr7=strcat('The CMI dataset has-',num2str(nrows),'-rows and-',num2str(ncols),'-columns of data.');
    parastr8=strcat('The mapping grid used was from file-',GridMatFileName,'.');
    parastr9=strcat(parastr7,parastr8);
    p3 = Paragraph(parastr9);
    p3.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p3);
    parastr1='This chart shows the Cloud Moisture Data. Under the plot,the first line shows the scan time.';
    parastr2=' The second line provides the waveband and resolution data.';
    parastr3=' Finally, the last line provides some statistics on the solar reflectance.';
    parastr4=' The Map Scale is-';
    parastr5=strcat(' This data is for band-',num2str(bandnum),'-which centered at-',num2str(bandwave),'-microns.');
    parastr6='In order to enhance cloud visibility a value of 0.025 was subtracted from CMI for plot purposes only.';
    parastr=strcat(parastr1,parastr2,parastr3,parastr4,MapFormFactor,'.',parastr5,parastr6);
    p1 = Paragraph(parastr);
    p1.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p1);
    parastr11='The CMI reflectance variable CAN report negative values or values greater than 1 .';
    parastr12=strcat('In this case the number of reporting pixels is-',num2str(numcmipixels),'. ');
    parastr13=strcat('According to the Data Quality Factors (DQF)-',num2str(numgoodpixels),'-were good pixels and-',...
        num2str(numbadpixels),'-were from bad pixels. ');
    parastr14=strcat('It should be noted that only - ',num2str(numuseable),'-pixels yielded reflectance values between 0 and 1.');
    parastr15='Note the CMI reflectance values are dimensionless .';
    parastr16=strcat(parastr11,parastr12,parastr13,parastr14,parastr15);
    p4 = Paragraph(parastr16);
    p4.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p4);
    JpegCounter=JpegCounter+1;
    JpegFileList{JpegCounter+1,1}=figstr;
    JpegFileList{JpegCounter+1,2}=jpegpath;
    close('all');
% Build a Rqmts Table
    if(ncallsCMI==1)
        RqmtsHdr=cell(1,2);
        RqmtsHdr{1,1}='Description';
        RqmtsHdr{1,2}='Rqmts Value';
        RqmtsTable=cell(1,1);
        RqmtsTable{1,1}='Geographic Coverage';
        RqmtsTable{1,2}='FullDisk/Conus/Meso';
        RqmtsTable{2,1}='Vertical Resolution';
        RqmtsTable{2,2}='N/A';
        RqmtsTable{3,1}='Horizontal Resolution';
        RqmtsTable{3,2}='0.5-2 Km';
        RqmtsTable{4,1}='Product Mapping Accuracy';
        RqmtsTable{4,2}='1 km';
        RqmtsTable{5,1}='Product Measurement Range';
        RqmtsTable{5,2}='N/A';
        RqmtsTable{6,1}='Product Measurement Accuracy';
        RqmtsTable{6,2}='Not Stated';
        RqmtsTable{7,1}='Product Refresh Rate-Full Disk';
        RqmtsTable{7,2}='15 minutes';
        RqmtsTable{8,1}='Product Refresh Rate-Conus';
        RqmtsTable{8,2}='5 minutes';
        RqmtsTable{9,1}='Product Refresh Rate-Meso';
        RqmtsTable{9,2}='30 seconds';
        RqmtsTable{10,1}='Data Latency';
        RqmtsTable{10,2}='Not Stated';
        RqmtsTable{11,1}='Product Extent Qualifier';
        RqmtsTable{11,2}='Not Stated';
        RqmtsTable{12,1}='Coverage Qualifier Qualifier';
        RqmtsTable{12,2}='Day/Night';
        br = PageBreak();
        add(chapter,br);
        T2=[RqmtsHdr;RqmtsTable];
        tbl2=Table(T2);
        tbl2.Style = [tbl2.Style {Border('solid','black','3px')}];
        tbl2.HAlign='center';
        tbl2.TableEntriesHAlign = 'center';
        tbl2.ColSep = 'single';
        tbl2.RowSep = 'single';
        r = row(tbl2,1);
        r.Style = [r.Style {Color('red'),Bold(true)}];
        bt2 = BaseTable(tbl2);
        tabletitle = Text('ABI CMI Metric Rqmts');
        tabletitle.Bold = false;
        bt2.Title = tabletitle;
        bt2.TableWidth="7in";
        add(chapter,bt2);
% Description of the Requirements table
        parastr41=strcat('The table above shows some of the requirements that were levied on the GOES satellite with respect to the CMI metric.');
        parastr42=strcat('Basic requirements are definited in 12 separate rows.');
        parastr43='This table shows that the metric can be returned at Full Disk/Conus or Meso levels.';
        parastr44=strcat('Mapping resolution is good with the horizontal resolution at that varies according to the ABI channel-the best resolution is 0.5 km.',...
            'The longer wavebands which are in the IR region offer a pixel footprint of about 2 km.');
        parastr45='The CMI is a cloud reflectance factor due to moisture and ranges from 0 to 1.';
        parastr46='Refresh rate for this metric ranges from a little as 30 seonds for meso scale up to 15 minutes for the full disk.';
        parastr47='ABI sensor wavebands span  the region from UV out to LWIR and thus can provide in day or night measurements.';
        parastr49=strcat(parastr41,parastr42,parastr43,parastr44,parastr45,parastr46,parastr47);
        p4 = Paragraph(parastr49);
        p4.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
        add(chapter,p4);
% Now show the data quality factors
        dqfflag1=100*DQFS.percent_good_pixel_qf;
        dqfflagstr1=num2str(dqfflag1,6);
        dqfflag2=100*DQFS.percent_conditionally_usable_pixel_qf;
        dqfflagstr2=num2str(dqfflag2,6);
        dqfflag3=100*DQFS.percent_out_of_range_pixel_qf;
        dqfflagstr3=num2str(dqfflag3,6);
        dqfflag4=100*DQFS.percent_no_value_pixel_qf;
        dqfflagstr4=num2str(dqfflag4,6);
        dqfflag5=100*DQFS.percent_focal_plane_temperature_threshold_exceeded_qf;
        dqfflagstr5=num2str(dqfflag5,6);
% Now build a DQF Table of key values
        DQFHdr = {'Item' '% Of Pixels'};
        DQFTable=cell(5,2);
        DQFTable{1,1}='Pct Good Quality Pixel';
        DQFTable{1,2}=dqfflagstr1;
        DQFTable{2,1}='Pct Conditionally Useable Pixel';
        DQFTable{2,2}=dqfflagstr2;
        DQFTable{3,1}='Pct Out Of Range Pixel';
        DQFTable{3,2}=dqfflagstr3;
        DQFTable{4,1}='Pct No Value Pixel';
        DQFTable{4,2}=dqfflagstr4;
        DQFTable{5,1}='Pct FPA Temp Exceeded';
        DQFTable{5,2}=dqfflagstr5;
        br = PageBreak();
        add(chapter,br);
        T4=[DQFHdr;DQFTable];
        tbl4=Table(T4);
        tbl4.Style = [tbl4.Style {Border('solid','black','3px')}];
        tbl4.HAlign='center';
        tbl4.TableEntriesHAlign = 'center';
        tbl4.ColSep = 'single';
        tbl4.RowSep = 'single';
        r = row(tbl4,1);
        r.Style = [r.Style {Color('red'),Bold(true)}];
        bt4 = BaseTable(tbl4);
        tabletitle = Text('DQF Table For ABI-CMI');
        tabletitle.Bold = false;
        bt4.Title = tabletitle;
        bt4.TableWidth="7in";
        add(chapter,bt4);
% Add text for this table
        parastr11=strcat('The DQF table above is intended to inform the user regarding the factors that play into the quality of the data.',...
            'The CMI metric has relatively few factors that can cause pixel output to be rejected.');
        parastr12=strcat('In the first row of the table is the per centage of all pixels that returned good data-',dqfflagstr1,'%.');
        parastr13=strcat('Rows 2 details the number of mariginal pixels-',dqfflagstr2,'%.');
        parastr19=strcat(parastr11,parastr12,parastr13);
        p2 = Paragraph(parastr19);
        p2.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
        add(chapter,p2);
    end
end
savestr=strcat('Saved CMI data plot to file-',figstr);
fprintf(fid,'%s\n',savestr);
fprintf(fid,'%s\n','------- Finished Plotting CMI data ------');
end

function centerImage(imageFile,rpt)
% Not used at present-Dec 31,2020 SMF
%Import the DOM API and report generator utility packages so that you do not have to use long, fully-qualified class names.
    import mlreportgen.dom.*
    import mlreportgen.utils.*
%Get the report's current page layout to determine the current page size and the page margins. The page layout information is used to calculate the page body size in order to size the layout table created in a subsequent step.
    pageLayout = getReportLayout(rpt);
    pageSize = pageLayout.PageSize;
    pageMargins = pageLayout.PageMargins;
%Calculate the page body width. The page body width denotes the page width available for the content and is determined by subtracting the left and right margin size from the page width. For DOCX output, gutter size also needs to be subtracted.
    bodyWidth = units.toInches(pageSize.Width) - ...
        units.toInches(pageMargins.Left) - ...
        units.toInches(pageMargins.Right);
    
    if strcmpi(rpt.Type,"docx")
        bodyWidth = bodyWidth - ...
            units.toInches(pageMargins.Gutter);
    end
    bodyWidth = sprintf("%0.2fin",bodyWidth);
%Calculate the page body height. The page body height denotes the page height available for the content and is determined by subtracting the top and bottom margin size from the page height. For PDF output, the header and footer sizes also need to be subtracted because the body extends from the bottom of the header to the top of the footer.
    bodyHeight = units.toInches(pageSize.Height) - ...
        units.toInches(pageMargins.Top) - ...
        units.toInches(pageMargins.Bottom);
    
    if strcmpi(rpt.Type,"pdf")
        bodyHeight = bodyHeight - ...
            units.toInches(pageMargins.Header) - ...
            units.toInches(pageMargins.Footer);
    end
    bodyHeight = sprintf("%0.2fin",bodyHeight);
%Create an Image object wrapped around the image file. Scale the image to fit the entry of the layout table created in a subsequent step.
    image = Image(imageFile);
    image.Style = [image.Style {ScaleToFit}];
%Wrap the image in a paragraph because PDF requires that an image reside in a paragraph. Update the paragraph style to make sure that there is no white space around the image.
    para = Paragraph(image);
    para.Style = [para.Style {OuterMargin("0in","0in","0in","0in")}];
%Add the paragraph that contains the image in a 1-by-1 invisible layout table (lo_table). A table is considered invisible when the borders are not defined for the table and its table entries.
    lo_table = Table({para});
%Span the table to the available page body width.
    lo_table.Width = bodyWidth;
%Span the only table entry to the available page body height. Also, specify the vertical and horizontal alignment formats to make sure that the image is centered both vertically and horizontally inside the table entry.
    lo_table.TableEntriesStyle = [lo_table.TableEntriesStyle ...
        { ...
        Height(bodyHeight), ...
        HAlign("center"), ...
        VAlign("middle") ...
        }];
%Add the layout table to the report.
    add(rpt,lo_table);
end


