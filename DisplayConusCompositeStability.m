function  DisplayConusCompositeStability(titlestr)
% Display a composite measure of the 5 stability indices on a CONUS map
% The Composite is produces but summing the 5 existing Stability masks
% where 0 means stable and 1 means unstable. If all five stability indicies
% point to an unstable pixel the max value would be 5.
% Project this data on a equiconic section map
% This uses the CONUS projection
% Note this routine is basically the same as DisplayCloudTopHeightsRev2.,
% Written By: Stephen Forczyk
% Created: Feb 22,2021
% Revised: ----
% Classification: Unclassified
% Valid range of Showater Index >4 to -10 K 
global MetaDataS;
global LIS CAPES TTS SIS KIS;
global FAPS;
global DQF_OverallS DQF_RetrievalS DQF_SkinTempS;
global TotAttRetS;
global CAPEOutlierPixelS LIOutlierPixelS KIOutlierPixelS;
global ShowOutlierPixelS TTIOutlierPixelS;
global CAPEStatS LIStatS TTStatS ShowStatS KIStatS;
global tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global AlgoS GoesWaveBand;
global TPWRS TRVS TotPixRS RROutPixCountS RainRateS;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global SZAS SZABS;
global RLZAS  RLZABS;
global LatitudeS LatitudeBoundsS;
global SoundingWaveS SoundingWaveIDS;
global TotAttempRetS;
global MeanDiffSoundingBandS StdevDiffSoundingBandS;
global GRBErrorsS L0ErrorsS;
global westEdge eastEdge northEdge southEdge;
global GOESFileName;
global RasterLats RasterLons;
global idebug isavefiles;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global DQFHdr DQFTable MiscHdr MiscTable RqmtsHdr RqmtsTable;
global DQFCauses DQFNormed DQFLabels;
global LIStability CAPEStability TTStability SIStability KIStability;
global CompositeStability;
global fracUnstableLI fracUnstableCAPE fracUnstableTT fracUnstableSI fracUnstableKI;
global RejectArray StabilityIndexNames;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath fid;
global smhrpath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
% additional paths needed for mapping
global matpath1 mappath;
global canadapath stateshapepath topopath;
global trajpath militarypath;
global figpath screencapturepath gridpath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath GOES16BandPaths;
if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end
fprintf(fid,'\n');
fprintf(fid,'%s\n','-----Start plot routine Display CONUS Composite stability Index-----');
eval(['cd ' gridpath(1:length(gridpath)-1)]);
[nrows,ncols]=size(SIS.values);
if((nrows==300) && (ncols==500))
   GridMatFileName='ConusStabilityIndexBoundaries.mat';
else
   disp('This does not work'); 
end
ntotpixels=nrows*ncols;
gridstr1=strcat('Loaded Map Grid From File=',GridMatFileName);
fprintf(fid,'%s\n',gridstr1);
load(GridMatFileName,'RasterLats','RasterLons');
dispstr=strcat('Loaded Grid Raster File-',GridMatFileName);
disp(dispstr)
% Create the composite index-insure that all 5 arrays are of the same size
% if they are not the same size abort this operation
[nrows1,ncols1]=size(LIStability);
[nrows2,ncols2]=size(CAPEStability);
[nrows3,ncols3]=size(TTStability);
[nrows4,ncols4]=size(SIStability);
[nrows5,ncols5]=size(KIStability);
igo=1;
nrowsb=nrows1;
ncolsb=ncols1;
if((nrows2~=nrowsb) || (nrows3~=nrowsb) || (nrows4~=nrowsb) || (nrows5~=nrowsb))
    igo=0;
end
if((ncols2~=ncolsb) || (ncols3~=ncolsb) || (ncols4~=ncolsb) || (ncols5~=ncolsb))
    igo=0;
end
if(igo==1)
    CompositeStability=zeros(nrowsb,ncolsb);
    CompositeStability=LIStability+CAPEStability+TTStability+SIStability+KIStability;
    minCompositeStab=min(min(CompositeStability));
    maxCompositeStab=max(max(CompositeStability));
    statstr1=strcat('Minimum Value CompositeStability=',num2str(minCompositeStab),'-Max Value SI=',num2str(maxCompositeStab));
    fprintf(fid,'%s\n',statstr1);
    CStab1D=reshape(CompositeStability,nrowsb*ncolsb,1);
    CStab1DS=sort(CStab1D);
    ntotpixels=nrowsb*ncolsb;
    [istable]=find(CStab1DS==0);
    a0=isempty(istable);
    if(a0==0)
        numstable=length(istable);
    else
        numstable=0;
    end
    fracstab=numstable/ntotpixels;
    [iunstable1]=find(CStab1DS==1);
    a1=isempty(iunstable1);
    if(a1==0)
        numunstable1=length(iunstable1);
    else
        numunstable1=0;
    end
    fracunstab1=numunstable1/ntotpixels;
    [iunstable2]=find(CStab1DS==2);
    a2=isempty(iunstable2);
    if(a2==0)
        numunstable2=length(iunstable2);
    else
        numunstable2=0;
    end
    fracunstab2=numunstable2/ntotpixels;
    [iunstable3]=find(CStab1DS==3);
    a3=isempty(iunstable3);
    if(a3==0)
        numunstable3=length(iunstable3);
    else
        numunstable3=0;
    end
    fracunstab3=numunstable3/ntotpixels;
    [iunstable4]=find(CStab1DS==4);
    a4=isempty(iunstable4);
    if(a4==0)
        numunstable4=length(iunstable4);
    else
        numunstable4=0;
    end
    fracunstab4=numunstable4/ntotpixels;  
    [iunstable5]=find(CStab1DS==5);
    a5=isempty(iunstable5);
    if(a5==0)
        numunstable5=length(iunstable5);
    else
        numunstable5=0;
    end
    fracunstab5=numunstable5/ntotpixels; 
    fractotunstab=sum(fracunstab1+fracunstab2+fracunstab3+fracunstab4+fracunstab5);
    checksum=fracstab+fractotunstab;
    statstr2=strcat('Frac Stable Pixels=',num2str(fracstab,6),'-Frac Unstable Pixels=',num2str(fractotunstab,6));
    fprintf(fid,'%s\n',statstr2);
    statstr3=strcat('Frac of Pixels Unstable By 1 Index=',num2str(fracunstab1,6));
    fprintf(fid,'%s\n',statstr3);
    statstr4=strcat('Frac of Pixels Unstable By 2 Indices=',num2str(fracunstab2,6));
    fprintf(fid,'%s\n',statstr4);
    statstr5=strcat('Frac of Pixels Unstable By 3 Indices=',num2str(fracunstab3,6));
    fprintf(fid,'%s\n',statstr5);
    statstr6=strcat('Frac of Pixels Unstable By 4 Indices=',num2str(fracunstab4,6));
    fprintf(fid,'%s\n',statstr6);
    statstr7=strcat('Frac of Pixels Unstable By 5 Indices=',num2str(fracunstab5,6));
    fprintf(fid,'%s\n',statstr7);
% Fetch the map limits
    westEdge=double(GeoSpatialS.geospatial_westbound_longitude);
    eastEdge=double(GeoSpatialS.geospatial_eastbound_longitude);
    southEdge=double(GeoSpatialS.geospatial_southbound_latitude);
    northEdge=double(GeoSpatialS.geospatial_northbound_latitude);
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
    axesm ('pcarree','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
         'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',10,'mlabellocation',20,...
         'MLabelParallel','south');
    set(gcf,'MenuBar','none');
    cmapland=colormap('jet');
    geoshow(RasterLats,RasterLons,CompositeStability,'DisplayType','texturemap');
    demcmap(CompositeStability,256,[],cmapland);
    hold on
    eval(['cd ' mappath(1:length(mappath)-1)]);
    load('USAHiResBoundaries.mat','USALat','USALon');
    plotm(USALat,USALon,'y');
    load('CanadaBoundaries.mat','CanadaLat','CanadaLon');
    plotm(CanadaLat,CanadaLon,'y');
    load('MexicoBoundaries.mat','MexicoLat','MexicoLon');
    plotm(MexicoLat,MexicoLon,'y');
    load('CubaBoundaries.mat','CubaLat','CubaLon');
    plotm(CubaLat,CubaLon,'y');
    load('DominicanRepublicBoundaries.mat','DRLat','DRLon');
    plotm(DRLat,DRLon,'y');
    load('HaitiBoundaries.mat','HaitiLat','HaitiLon');
    plotm(HaitiLat,HaitiLon,'y');
    load('BelizeBoundaries.mat','BelizeLat','BelizeLon');
    plotm(BelizeLat,BelizeLon,'y');
    load('GautemalaBoundaries.mat','GautemalaLat','GautemalaLon');
    plotm(GautemalaLat,GautemalaLon,'y')
    load('JamaicaBoundaries.mat','JamaicaLat','JamaicaLon');
    plotm(JamaicaLat,JamaicaLon,'y');
    load('NicaraguaBoundaries.mat','NicaraguaLat','NicaraguaLon');
    plotm(NicaraguaLat,NicaraguaLon,'y')
    load('HondurasBoundaries.mat','HondurasLat','HondurasLon');
    plotm(HondurasLat,HondurasLon,'y')
    load('ElSalvadorBoundaries.mat','ElSalvadorLat','ElSalvadorLon');
    plotm(ElSalvadorLat,ElSalvadorLon,'y');
    load('PanamaBoundaries.mat','PanamaLat','PanamaLon');
    plotm(PanamaLat,PanamaLon,'y');
    load('ColumbiaBoundaries.mat','ColumbiaLat','ColumbiaLon');
    plotm(ColumbiaLat,ColumbiaLon,'y');
    load('VenezuelaBoundaries.mat','VenezuelaLat','VenezuelaLon');
    plotm(VenezuelaLat,VenezuelaLon,'y')
    load('PeruBoundaries.mat','PeruLat','PeruLon');
    plotm(PeruLat,PeruLon,'y');
    load('EcuadorBoundaries.mat','EcuadorLat','EcuadorLon');
    plotm(EcuadorLat,EcuadorLon,'y')
    load('BrazilBoundaries.mat','BrazilLat','BrazilLon');
    plotm(BrazilLat,BrazilLon,'y');
    load('BoliviaBoundaries.mat','BoliviaLat','BoliviaLon');
    plotm(BoliviaLat,BoliviaLon,'y')
    load('ChileBoundaries.mat','ChileLat','ChileLon');
    plotm(ChileLat,ChileLon,'y');
    load('ArgentinaBoundaries.mat','ArgentinaLat','ArgentinaLon');
    plotm(ArgentinaLat,ArgentinaLon,'y');
    load('UruguayBoundaries.mat','UruguayLat','UruguayLon');
    plotm(UruguayLat,UruguayLon,'y');
    load('CostaRicaBoundaries.mat','CostaRicaLat','CostaRicaLon');
    plotm(CostaRicaLat,CostaRicaLon,'y');
    load('FrenchGuianaBoundaries.mat','FrenchGuianaLat','FrenchGuianaLon');
    plotm(FrenchGuianaLat,FrenchGuianaLon,'y');
    load('GuyanaBoundaries.mat','GuyanaLat','GuyanaLon');
    plotm(GuyanaLat,GuyanaLon,'y');
    load('SurinameBoundaries.mat','SurinameLat','SurinameLon');
    plotm(SurinameLat,SurinameLon,'y');
    set(gcf,'Position',[hor1 vert1 widd lend])
    title(titlestr)
    hold off
    tightmap;
    colorbar;
    newaxesh=axes('Position',[0 0 1 1]);
    set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
    tx1=.13;
    ty1=.25;
    txtstr1=strcat('Start Scan-Y',num2str(YearS),'-D-',num2str(DayS),'-H-',...
        num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS),'-----',MonthDayYearStr);
    txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',12);
    tx2=.80;
    ty2=.75;
    txtstr2='Composite-Index';
    txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',12);
    tx3=.13;
    ty3=.21;
    txtstr3=strcat('Frac Unstable By 1 Index=',num2str(fracunstab1,5),'-Frac By 2 Indices=',num2str(fracunstab2,5),...
        '-Frac By 3 Indices=',num2str(fracunstab3,5));
    txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',12);
    set(newaxesh,'Visible','Off');
    % Save this chart
    figstr=strcat(titlestr,'.jpg');
    eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
    actionstr='print';
    typestr='-djpeg';
    [cmdString]=MyStrcat2(actionstr,typestr,figstr);
    eval(cmdString);
    plotstr1=strcat('Saved Composite Stability Plots as-',figstr);
    disp(plotstr1);
    fprintf(fid,'%s\n',plotstr1);
    pause(chart_time);
    JpegCounter=JpegCounter+1;
    JpegFileList{JpegCounter+1,1}=figstr;
    JpegFileList{JpegCounter+1,2}=jpegpath;
    if((iCreatePDFReport==1) && (RptGenPresent==1))
        [ibreak]=strfind(GOESFileName,'_e');
        is=1;
        ie=ibreak(1)-1;
        GOESShortFileName=GOESFileName(is:ie);
        br = PageBreak();
        add(chapter,br);
        add(chapter,Section('Composite Index Map'));
        imdata = imread(figstr);
        [nhigh,nwid,ndepth]=size(imdata);
        image = mlreportgen.report.FormalImage();
        image.Image = which(figstr);
        pdftxtstr=strcat('Composite Stability Index For File-',GOESShortFileName);
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
% Now add some text -start by decribing the Composite Stability Index Metric
        parastr181=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
        parastr182='As shown above this Composite Index was derived as a numerical sum of the 5 standard Stability Indices.';
        parastr183='Since the index of 5 stability measures the values range from 0 to 5.';
        parastr184='In each of these indices a 0 indicates a stable pixel and a 1 an unstable index.';
        parastr185='Higher values of this index indicate that the pixel was judged unstable by that number of indices.';
        parastr186=strcat('The fraction of unstable pixels is=',num2str(fracunstab1,5),'.');
        parastr187='Note that this fraction is based on pixels that are deemed unstable by 1 measure of stability. This is a very liberal definition of instability'; 
        parastr188=strcat('If a more strict definition requring at least 2 indices to show instability the fraction of unstable pixels drops to=',num2str(fracunstab2,5),'.');
        parastr189=strcat(parastr181,parastr182,parastr183,parastr184,parastr185,parastr186,parastr187,parastr188);
        p18 = Paragraph(parastr189);
        p18.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
        add(chapter,p18);
        close('all');
% Now build a table showsing how the indices performed
        RejectArray=zeros(5,1);
        RejectArray(1,1)=fracUnstableLI;
        RejectArray(2,1)=fracUnstableCAPE;
        RejectArray(3,1)=fracUnstableTT;
        RejectArray(4,1)=fracUnstableSI;
        RejectArray(5,1)=fracUnstableKI;
        [RejectArraySort,RIndex]=sort(RejectArray,'descend');
        StabilityIndexNames=cell(5,1);
        StabilityIndexNames{1,1}='LI';
        StabilityIndexNames{2,1}='CAPE';
        StabilityIndexNames{3,1}='TT';
        StabilityIndexNames{4,1}='SI';
        StabilityIndexNames{5,1}='KI';
        MiscHdr=cell(1,7);
        MiscTable=cell(1,1);
        MiscHdr{1,1}='Stab Index';
        MiscHdr{1,2}='Min Val';
        MiscHdr{1,3}='Mean Val';
        MiscHdr{1,4}='Max Val';
        MiscHdr{1,5}='Std Dev';
        MiscHdr{1,6}='Frac Unstab';
        MiscHdr{1,7}='Rejection Rank';
        MiscTable{1,1}='--LI--';
        LImin=LIStatS.values1;
        LImean=LIStatS.values3;
        LImax=LIStatS.values2;
        LIstdev=LIStatS.values4;
        MiscTable{1,2}=sprintf('%0.5f',LImin);
        MiscTable{1,3}=sprintf('%0.5f',LImean);
        MiscTable{1,4}=sprintf('%0.5f',LImax);
        MiscTable{1,5}=sprintf('%0.5f',LIstdev);
        MiscTable{1,6}=sprintf('%0.5f',fracUnstableLI);
        MiscTable{1,7}=RIndex(1);
        MiscTable{2,1}='--CAPE--';
        CAPEmin=CAPEStatS.values1;
        CAPEmean=CAPEStatS.values3;
        CAPEmax=CAPEStatS.values2;
        CAPEstdev=CAPEStatS.values4;
        MiscTable{2,2}=sprintf('%0.5f',CAPEmin);
        MiscTable{2,3}=sprintf('%0.5f',CAPEmean);
        MiscTable{2,4}=sprintf('%0.5f',CAPEmax);
        MiscTable{2,5}=sprintf('%0.5f',CAPEstdev);
        MiscTable{2,6}=sprintf('%0.5f',fracUnstableCAPE);
        MiscTable{2,7}=RIndex(2);
        MiscTable{3,1}='--TT--';
        TTmin=TTStatS.values1;
        TTmean=TTStatS.values3;
        TTmax=TTStatS.values2;
        TTstdev=TTStatS.values4;
        MiscTable{3,2}=sprintf('%0.5f',TTmin);
        MiscTable{3,3}=sprintf('%0.5f',TTmean);
        MiscTable{3,4}=sprintf('%0.5f',TTmax);
        MiscTable{3,5}=sprintf('%0.5f',TTstdev);
        MiscTable{3,6}=sprintf('%0.5f',fracUnstableTT);
        MiscTable{3,7}=RIndex(3);
        MiscTable{4,1}='--SI--';
        SImin=ShowStatS.values1;
        SImean=ShowStatS.values3;
        SImax=ShowStatS.values2;
        SIstdev=ShowStatS.values4;
        MiscTable{4,2}=sprintf('%0.5f',SImin);
        MiscTable{4,3}=sprintf('%0.5f',SImean);
        MiscTable{4,4}=sprintf('%0.5f',SImax);
        MiscTable{4,5}=sprintf('%0.5f',SIstdev);
        MiscTable{4,6}=sprintf('%0.5f',fracUnstableSI);
        MiscTable{4,7}=RIndex(4);
        KImin=KIStatS.values1;
        KImean=KIStatS.values3;
        KImax=KIStatS.values2;
        KIstdev=KIStatS.values4;
        MiscTable{5,1}='--KI--';
        MiscTable{5,2}=sprintf('%0.5f',KImin);
        MiscTable{5,3}=sprintf('%0.5f',KImean);
        MiscTable{5,4}=sprintf('%0.5f',KImax);
        MiscTable{5,5}=sprintf('%0.5f',KIstdev);
        MiscTable{5,6}=sprintf('%0.5f',fracUnstableKI);
        MiscTable{5,7}=RIndex(5);
% Now add this table to the Report
        T10=[MiscHdr;MiscTable];
        tbl10=Table(T10);
        tbl10.Style = [tbl10.Style {Border('solid','black','3px')}];
        tbl10.HAlign='center';
        tbl10.TableEntriesHAlign = 'center';
        tbl10.ColSep = 'single';
        tbl10.RowSep = 'single';
        r = row(tbl10,1);
        r.Style = [r.Style {Color('red'),Bold(true)}];
        bt10 = BaseTable(tbl10);
        tabletitle = Text('Stability Measure Of Effectiveness');
        tabletitle.Bold = false;
        bt10.Title = tabletitle;
        bt10.TableWidth="7in";
        add(chapter,bt10);
% Now add a paragraph to discuss
        parastr191='The table above is intended to provide some details regarding which stability indices flagged the most pixels as unstable.';
        parastr192='Entries in the table are as follows.Each row provides the data on one of the 5 stability indices-the 7 columns provide details.';
        parastr193='Column 1 has the code for the specific index while colums 2 thru 5 present top level statistics for the index corresponding to that row.';
        parastr194='The fraction of pixels found to be unstable for that index are shown in column 6 while column 7 provides the ranking.';
        parastr195='If the ranking is 1 this is measure that declares the most unstable pixels.';
        parastr196=strcat('Overall-',num2str(fracstab,6),'-of the pixels were not found to be unstable by any of the 5 indices while-',...
            num2str(fracunstab1,6),'-of all pixels were unstable by at least one measurement.');
        parastr197='Typically, the 5 different stability indices produce a wide range of values-a high value may not be the best value depending on location and time of year.';
        parastr199=strcat(parastr191,parastr192,parastr193,parastr194,parastr195,parastr196,parastr197);
        p19 = Paragraph(parastr199);
        p19.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
        add(chapter,p19);

    end
else
        fprintf(fid,'%s\n','Could not create plot because all 5 Stability Arrays were not the same size');
end
add(rpt,chapter);
fprintf(fid,'%s\n','-----Exit DisplayConus Composite Stability Index Data-----');
fprintf(fid,'\n');
end


