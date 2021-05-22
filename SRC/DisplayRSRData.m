function [nvals]=DisplayRSRData(titlestr,itype)
% Display the Refelected ShortWave Radiation (RSR) values
% at the Top Of the Atmosphere (TOA)
 
% Written By: Stephen Forczyk
% Created: April 26,2021
% Revised: --------
% Classification: Unclassified

global BandDataS MetaDataS;
global RSRS DQFS tS tBS ;
global SatDataS GeoSpatialS;
global lat_imageS lat_image_BS;
global lon_imageS lon_image_BS;
global GoesWaveBand MapFormFactor;
global GOESFileName ;
global LatS LonS;
global RLZAS QLZAS RLZABS QLZABS;
global RSZAS QSZAS RSZABS QSZABS;
global RSRProdWaveS RSRProdWaveBS;
global RetPixCountS LZAPixCountS OutlierPixCountS;
global ImageCloudFracS SZAStatS RSRStatS;
global Algo2S ProcessParamTS AlgoProductTS Error1S ;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global DQFHdr DQFTable MiscHdr MiscTable RqmtsHdr RqmtsTable;
global PhaseHdr PhaseTable;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global westEdge eastEdge northEdge southEdge;


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

if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end
fprintf(fid,'\n');
if(itype==1)
    fprintf(fid,'%s\n','------- Plot RSR Data For The Full Disk ------');
elseif(itype==2)
    fprintf(fid,'%s\n','------- Plot RSR Data For Conus------');
elseif(itype==3)
    fprintf(fid,'%s\n','------- Plot RSR Data Meso1 Scale ------'); 
elseif(itype==4)
    fprintf(fid,'%s\n','------- Plot RSR Data For Meso2 Scale ------'); 
else
    
end
eval(['cd ' gridpath(1:length(gridpath)-1)]);
RSR=RSRS.values;
measunits=RSRS.units;
Lats=LatS.values';
Lons=LonS.values';
nrows=length(Lats);
ncols=length(Lons);
scalebarlen=1000;
scalebarloc='nw'; % location of scale (sw=southwest)
% This type of plot uses a different scheme to generate a gris raster as
% that is how it is stored by GOES
RasterLats=zeros(nrows,ncols);
RasterLons=zeros(nrows,ncols);
for i=1:nrows
    for j=1:ncols
        RasterLats(i,j)=Lats(i,1);
        RasterLons(i,j)=Lons(j,1);
    end
end


% Get some stats on the The RSR
[nrows,ncols]=size(RSR);
RSR1D=reshape(RSR,nrows*ncols,1);
RSR1DS=sort(RSR1D);
a1=isnan(RSR1D);
numnan=sum(a1);

maxRSR=max(RSR1D);
minRSR=min(RSR1D);
nvals=nrows*ncols-numnan;
num01=round(.01*nvals);
num25=round(.25*nvals);
num50=round(.50*nvals);
num75=round(.75*nvals);
num99=round(.99*nvals);
if(nvals>100)
    RSR01=RSR1DS(num01,1);
    RSR25=RSR1DS(num25,1);
    RSR50=RSR1DS(num50,1);
    RSR75=RSR1DS(num75,1);
    RSR99=RSR1DS(num99,1);
    stats1str=strcat('The  minimum RSR value is-',num2str(minRSR,6),'-W/m^2');
    stats2str=strcat('The  1 ptile RSR value is-',num2str(RSR01,6),'-W/m^2');
    stats3str=strcat('The 25 ptile RSR value is-',num2str(RSR25,6),'-W/m^2');
    stats4str=strcat('The 50 ptile RSR value is-',num2str(RSR50,6),'-W/m^2');
    stats5str=strcat('The 75 ptile RSR value is-',num2str(RSR75,6),'-W/m^2');
    stats6str=strcat('The 99 ptile RSR value is-',num2str(RSR99,6),'-W/m^2');
    stats7str=strcat('The  maximum RSR value is-',num2str(maxRSR,6),'-W/m^2');
    fprintf(fid,'%s\n','***** RSR Stats Follow *****');
    fprintf(fid,'%s\n',stats1str);
    fprintf(fid,'%s\n',stats2str);
    fprintf(fid,'%s\n',stats3str);
    fprintf(fid,'%s\n',stats4str);
    fprintf(fid,'%s\n',stats5str);
    fprintf(fid,'%s\n',stats6str);
    fprintf(fid,'%s\n',stats7str);
    fprintf(fid,'%s\n','***** RSR Stats End*****');
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
    fprintf(fid,'%s\n',maplimitstr4);


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
         'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',10,'mlabellocation',20,...
         'MLabelParallel','south','Frame','on','FontColor','b'); 
         gridm('GLineStyle','-','Gcolor',[.1 .1 .1],'Galtitude',.002,'MLineLocation',10,...
        'PLineLocation',10)
    elseif((itype==3)||(itype==4))
        axesm ('pcarree','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
         'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',2,'mlabellocation',2,...
         'MLabelParallel','south','Frame','on','FontColor','b');
        gridm('GLineStyle','-','Gcolor',[.1 .1 .1],'Galtitude',.002,'MLineLocation',2,...
        'PLineLocation',2)
    end
    set(gcf,'MenuBar','none');
    set(gcf,'Position',[hor1 vert1 widd lend])
    a1=isnan(RSR);
    numnan=sum(sum(a1));
    if(numnan>0)
        for i=1:nrows
            for j=1:ncols
               TF=a1(i,j);
               if(TF==1)
                   RSR(i,j)=-0.2*abs(minRSR);
               end
            end
        end
    end
    ab=1;
    geoshow(RasterLats',RasterLons',RSR','DisplayType','texturemap');
    demcmap(RSR',256);
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
    if(itype==1)
        camposm(0,-75,3);
    end
    title(titlestr)

    hold off
    tightmap;
    if((itype==3)|| (itype==4))
        scalebar('length',scalebarlen,'units','km','color','r','location',scalebarloc,'fontangle','bold',...
            'RulerStyle','patches','orientation','vertical');
    end
    hc=colorbar;

    newaxesh=axes('Position',[0 0 1 1]);
    set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
    if(itype==1)
        Pos=get(hc,'Position');
        PosyL=.80*Pos(1,2);
        PosyU=1.03*(Pos(1,2)+Pos(1,4));
        tx1=.13;
        ty1=PosyL;
        tx2=tx1;
        ty2=PosyL;
        txtstr2=strcat('Min RSR =',num2str(minRSR,5),'-Median RSR',num2str(RSR50,5),'-Max RSR =',...
            num2str(maxRSR,5),'-all in W/m^2');
        txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',10);
        tx3=Pos(1,1);
        ty3=1.01*PosyU;
        txtstr3='RSR';
        txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',10);
        tx4=tx1;
        ty4=ty2-.04;
    elseif(itype==2)
        Pos=get(hc,'Position');
        PosyL=.80*Pos(1,2);
        PosyU=1.03*(Pos(1,2)+Pos(1,4));
        tx1=.13;
        ty1=PosyL;
        tx2=tx1;
        ty2=PosyL;
        txtstr2=strcat('Min RSR =',num2str(minRSR,5),'-Median RSR=',num2str(RSR50,5),'-Max RSR =',...
            num2str(maxRSR,5),'-all in W/m^2');
        txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',10);
        tx3=Pos(1,1);
        ty3=1.01*PosyU;
        txtstr3='RSR';
        txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',10);
        tx4=tx1;
        ty4=ty2-.04;
    elseif((itype==3)|| (itype==4))


    end
    set(newaxesh,'Visible','Off');
    % Save this chart
    figstr=strcat(titlestr,'.jpg');
    eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
    actionstr='print';
    typestr='-djpeg';
    [cmdString]=MyStrcat2(actionstr,typestr,figstr);
    eval(cmdString);
    pause(chart_time);
    JpegCounter=JpegCounter+1;
    JpegFileList{JpegCounter+1,1}=figstr;
    JpegFileList{JpegCounter+1,2}=jpegpath;
    close('all');
    savestr=strcat('Saved RSR data plot to file-',figstr);
    fprintf(fid,'%s\n',savestr);
    if((iCreatePDFReport==1) && (RptGenPresent==1))
        [ibreak]=strfind(GOESFileName,'_e');
        is=1;
        ie=ibreak(1)-1;
        GOESShortFileName=GOESFileName(is:ie);
        headingstr1=strcat('TOA-RSR-',GOESShortFileName);
        chapter = Chapter("Title",headingstr1);
        sectionstr=strcat('RSR-',MapFormFactor);
        add(chapter,Section(sectionstr));
        imdata = imread(figstr);
        [nhigh,nwid,ndepth]=size(imdata);
        image = mlreportgen.report.FormalImage();
        image.Image = which(figstr);% 
        pdftxtstr=strcat('TOA-RSR-For File-',GOESShortFileName);
        pdftext = Text(pdftxtstr);
        pdftext.Color = 'red';
        image.Caption = pdftext;
        nhighs=floor(nhigh/2.5);
        nwids=floor(nwid/2.5);
        heightstr=strcat(num2str(nhighs),'px');
        widthstr=strcat(num2str(nwids),'px');
        image.Height = heightstr;
        image.Width = widthstr;
        image.ScaleToFit=0;
        add(chapter,image);
    % Now add some text 
        wavelength=RSRProdWaveS.values;
        parastr11=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
        parastr12='Plotted on the chart is the Reflected Shortwave Radiation (RSR) from the TOA as seen by the ABI sensor.';
        parastr13=strcat('This Map uses data taken in the-',MapFormFactor,'-format.');
        parastr14='Basic statistics of the RSR are shown below the chart.';
        parastr15='The RSR and the Downward ShortWave Radation (DSR) are the two components that make up the earths radiation budget.';
        parastr16='The incoming sun light is strongest in the SWIR regions of the spectrum and these two items are taken from these channels.';
        parastr17=strcat('The data making up this statistic is taken at-',num2str(wavelength,4),'-microns.');
        parastr19=strcat(parastr11,parastr12,parastr13,parastr14,parastr15,parastr16,parastr17);
        p1 = Paragraph(parastr19);
        p1.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
        add(chapter,p1);
    % Now build a Requirements Table
        RqmtsHdr={'Item' 'Value'};
        RqmtsTable=cell(10,2);
        RqmtsTable{1,1}='Geographic Coverage';
        RqmtsTable{1,2}='Conus/Full Disk';
        RqmtsTable{2,1}='Vertical Resolution';
        RqmtsTable{2,2}='N/A';
        RqmtsTable{3,1}='Horizontal Resolution';
        RqmtsTable{3,2}='25 Km';
        RqmtsTable{4,1}='Mapping Accuracy';
        RqmtsTable{4,2}='2 Km';
        RqmtsTable{5,1}='Measurement Range';
        RqmtsTable{5,2}='0-1300 w/m^2';
        RqmtsTable{6,1}='Measurement Accuracy';
        RqmtsTable{6,2}='65-110 W/m^2';
        RqmtsTable{7,1}='Refresh Rate';
        RqmtsTable{7,2}='60 min';
        RqmtsTable{8,1}='Latency';
        RqmtsTable{8,2}='3236 sec';
        RqmtsTable{9,1}='Measurement Precision';
        RqmtsTable{9,2}='100-130 W/m^2';
        RqmtsTable{10,1}='Temporal Coverage';
        RqmtsTable{10,2}='Clear Day with solar elevation >25 deg';
        T2=[RqmtsHdr;RqmtsTable];
        tb21=Table(T2);
        tb21.Style = [tb21.Style {Border('solid','black','3px')}];
        tb21.HAlign='center';
        tb21.TableEntriesHAlign = 'center';
        tb21.ColSep = 'single';
        tb21.RowSep = 'single';
        r = row(tb21,1);
        r.Style = [r.Style {Color('red'),Bold(true)}];
        bt2 = BaseTable(tb21);
        tabletitle = Text('RSR Sensor Requirements');
        tabletitle.Bold = false;
        bt2.Title = tabletitle;
        bt2.TableWidth="7in";
        add(chapter,bt2);
    % Add text for this table
        parastr21='Key requirements on the ABI sensor needed to collect gather required data for calculation of the RSR metric are in the table above.';
        parastr22='Note that this data is derived for the Full Disk and Conus form factor only and the refresh rate is only once per hour.';
        parastr23='The data latency is long in keeping with the slow refresh rate.';
        parastr24='The measurement accuracy and precision values are also modest-as such other sensors on different platforms can provide better data.';
        parastr25='Because the ABI sensor uses shortwave band to collect the needed data operation is limited to daytime,clear weather conditions.';
        parastr26='The solar elevation angle must exceed 25 degrees and the local zenith angle must be less than 70 degrees.';
        parastr29=strcat(parastr21,parastr22,parastr23,parastr24,parastr25,parastr26);
        p2 = Paragraph(parastr29);
        p2.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
        add(chapter,p2);
    % Build a table to hold Miscellaneous data
        MiscHdr ={'Item' 'Value'};
        MiscTable=cell(1,1);
        MiscTable{1,1}='percent_good_quality_qf';
        dqfflag1str=num2str(DQFS.percent_good_quality_qf,6);
        MiscTable{1,2}=dqfflag1str;
        MiscTable{2,1}='percent_degraded_quality_qf';
        dqfflag2str=num2str(DQFS.percent_degraded_quality_or_invalid_qf,6);
        MiscTable{2,2}=dqfflag2str;
        ab=2;
        MiscTable{3,1}='Number of ShortWave Radiation Pixel Retrievals';
        RetPixCount=RetPixCountS.values;
        MiscTable{3,2}=num2str(RetPixCount,6);
        LZAPixCount=LZAPixCountS.values;
        MiscTable{4,1}='Number of ShortWave Radiation Pixel Retrievals < LZA Threshold';
        MiscTable{4,2}=num2str(LZAPixCount,6);
        OutlierPixCount=OutlierPixCountS.values;
        MiscTable{5,1}='Number of TOA Pixels outisde valid range';
        MiscTable{5,2}=num2str(OutlierPixCount,6);
        MiscTable{6,1}='Total Cloud Fraction In Image';
        ImageCloudFrac=ImageCloudFracS.values;
        MiscTable{6,2}=num2str(ImageCloudFrac,6);
        minRSR=RSRStatS.values1;
        meanRSR=RSRStatS.values3;
        maxRSR=RSRStatS.values2;
        stdevRSR=RSRStatS.values4;
        MiscTable{7,1}='Min RSR Value';
        MiscTable{7,2}=strcat(num2str(minRSR,6),'-W/m^2');
        MiscTable{8,1}='Mean RSR Value';
        MiscTable{8,2}=strcat(num2str(meanRSR,6),'-W/m^2');
        MiscTable{9,1}='Max RSR Value';
        MiscTable{9,2}=strcat(num2str(maxRSR,6),'-W/m^2');
        MiscTable{10,1}='Stdev RSR Value';
        MiscTable{10,2}=strcat(num2str(stdevRSR,6),'-W/m^2');
        [nrows,ncols]=size(RSR);
        sizestr=strcat(num2str(nrows,4),'-x-',num2str(ncols,4));
        MiscTable{11,1}='RSR Size nrows x ncols';
        MiscTable{11,2}=sizestr;
        ab=1;
        br = PageBreak();
        add(chapter,br);
        T3=[MiscHdr;MiscTable];
        tbl3=Table(T3);
        tbl3.Style = [tbl3.Style {Border('solid','black','3px')}];
        tbl3.HAlign='center';
        tbl3.TableEntriesHAlign = 'center';
        tbl3.ColSep = 'single';
        tbl3.RowSep = 'single';
        r = row(tbl3,1);
        r.Style = [r.Style {Color('red'),Bold(true)}];
        bt3 = BaseTable(tbl3);
        tabletitle = Text('RSR Metric Misc Data');
        tabletitle.Bold = false;
        bt3.Title = tabletitle;
        bt3.TableWidth="7in";
        add(chapter,bt3);
    % Add text for this Misc Data table
        parastr21='The Table above shows the values for a number of quantities relevant to understanding the data in the RSR file.';
        parastr22='Rows 1 and 2 illustrate the data quality of the returned RSR values.Note that these two entries sum to more than 100% as they are not exclusive.';
        parastr23='Entries for rows 3 through 5 detail how many pixels returned RSR values and if they were within LZA and range limits.';
        parastr24='Row 6 reports on what fraction of the pixels in these scene were cloudy-no RSR values are computed for these pixels.';
        parastr25='The final 4 rows provide some RSR statistics as computed by the GOES software-note that the solar constant is 1454 W/m^2 so no value can exeeed this.';
        parastr29=strcat(parastr21,parastr22,parastr23,parastr24,parastr25);
        p2 = Paragraph(parastr29);
        p2.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
        add(chapter,p2);
    end % Loop for PDF report

end % Loop for at least 100 data points
if(nvals<101)
    fig = uifigure;
    message='Could Not Return Enough RSR Data To Analyze';
    uialert(fig,message,'Insufficient RSR Data');
    uiwait(fig,10);
    close(fig);
end
fprintf(fid,'%s\n','------- Finished Plotting RSR TOA Data ------');
end


