function CreateAerosolDataAlgoDesc
% This function will create a report section that will desribe
% the algorithms used to create the data that was read in during execution
% of the ReadAerosolData.m script. The basic reference document is
% ABI Aerosol Detection Product-Rev 3 which is part of the basic
% documentation available on the Government website
% https://www.goes-r.gov/resources/docs.html
% Written By: Stephen Forczyk
% Created: Feb 10,2021
% Revised: 
% Classification: Unclassified
global GoesWaveBand GoesWaveBand2 GoesWaveBandTable;
global NumProcFiles ProcFileList;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter tocc;
global JpegCounter JpegFileList;
global DMWDTable1 DMWDHdrs;
global FPSReq FPSHdrs;

global fid;
global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath tiffpath;
global smhrpath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
global ColorList RGBVals ColorList2 xkcdVals LandColors;
global orange bubblegum brown brightblue;
% additional paths needed for mapping
global matpath1 mappath matlabpath;
global jpegpath northamericalakespath logpath pdfpath govjpegpath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath GOES16CloudTopTemppath GOES16Lightningpath;
global GOES16ConusBand1path shapefilepath Countryshapepath figpath;
global mappath gridpath countyshapepath nationalshapepath summarypath;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;

% Build same tables
DMWDTable1=cell(16,5);
DMWDHdrs=cell(1,5);
DMWDHdrs{1,1}='Band #';
DMWDHdrs{1,2}='WaveBand-Microns';
DMWDHdrs{1,3}='Cent Wavelength-Microns';
DMWDHdrs{1,4}='Nom IFOV-Km';
DMWDHdrs{1,5}='Used';
DMWDTable1{1,1}='1';
DMWDTable1{1,2}='0.45-0.49';
DMWDTable1{1,3}='0.47';
DMWDTable1{1,4}='1';
DMWDTable1{1,5}='No';
DMWDTable1{2,1}='2';
DMWDTable1{2,2}='0.59-0.69';
DMWDTable1{2,3}='0.64';
DMWDTable1{2,4}='0.5';
DMWDTable1{2,5}='Yes';
DMWDTable1{3,1}='3';
DMWDTable1{3,2}='0.846-0.885';
DMWDTable1{3,3}='0.86';
DMWDTable1{3,4}='1';
DMWDTable1{3,5}='No';
DMWDTable1{4,1}='4';
DMWDTable1{4,2}='1.371-1.386';
DMWDTable1{4,3}='1.38';
DMWDTable1{4,4}='2';
DMWDTable1{4,5}='No';
DMWDTable1{5,1}='5';
DMWDTable1{5,2}='1.58-1.64';
DMWDTable1{5,3}='1.61';
DMWDTable1{5,4}='1';
DMWDTable1{5,5}='No';
DMWDTable1{6,1}='6';
DMWDTable1{6,2}='2.26';
DMWDTable1{6,3}='1.61';
DMWDTable1{6,4}='2';
DMWDTable1{6,5}='No';
DMWDTable1{7,1}='7';
DMWDTable1{7,2}='3.80-4.00';
DMWDTable1{7,3}='3.9';
DMWDTable1{7,4}='2';
DMWDTable1{7,5}='Yes';
DMWDTable1{8,1}='8';
DMWDTable1{8,2}='5.77-6.6';
DMWDTable1{8,3}='6.15';
DMWDTable1{8,4}='2';
DMWDTable1{8,5}='Yes';
DMWDTable1{9,1}='9';
DMWDTable1{9,2}='6.75-7.15';
DMWDTable1{9,3}='7.0';
DMWDTable1{9,4}='2';
DMWDTable1{9,5}='Yes';
DMWDTable1{10,1}='10';
DMWDTable1{10,2}='7.24-7.44';
DMWDTable1{10,3}='7.4';
DMWDTable1{10,4}='2';
DMWDTable1{10,5}='Yes';
DMWDTable1{11,1}='11';
DMWDTable1{11,2}='8.3-8.7';
DMWDTable1{11,3}='8.5';
DMWDTable1{11,4}='2';
DMWDTable1{11,5}='No';
DMWDTable1{12,1}='12';
DMWDTable1{12,2}='9.42-9.8';
DMWDTable1{12,3}='9.7';
DMWDTable1{12,4}='2';
DMWDTable1{12,5}='No';
DMWDTable1{13,1}='13';
DMWDTable1{13,2}='10.1-10.6';
DMWDTable1{13,3}='10.35';
DMWDTable1{13,4}='2';
DMWDTable1{13,5}='No';
DMWDTable1{14,1}='14';
DMWDTable1{14,2}='10.8-11.6';
DMWDTable1{14,3}='11.2';
DMWDTable1{14,4}='2';
DMWDTable1{14,5}='Yes';
DMWDTable1{15,1}='15';
DMWDTable1{15,2}='11.8-12.8';
DMWDTable1{15,3}='12.3';
DMWDTable1{15,4}='2';
DMWDTable1{15,5}='No';
DMWDTable1{16,1}='16';
DMWDTable1{16,2}='13.0-13.6';
DMWDTable1{16,3}='13.3';
DMWDTable1{16,4}='2';
DMWDTable1{16,5}='No';
FPSReq=cell(10,2);
FPSReq{1,1}='Geographic Coverage';
FPSReq{1,2}='Full Disk,CONUS,MesoScale';
FPSReq{2,1}='Vertical Resolution';
FPSReq{2,2}='200mB at Cloud Tops';
FPSReq{3,1}='Horizontal Resolution';
FPSReq{3,2}='10 Km';
FPSReq{4,1}='Mapping Accuracy';
FPSReq{4,2}='5 Km';
FPSReq{5,1}='Measurement Range';
FPSReq{5,2}='Speed 0-300 kts Dircetion 0-360 deg';
FPSReq{6,1}='Measurement Accuracy';
FPSReq{6,2}='7.5 m/sec';
FPSReq{7,1}='Refresh Rate Mode 3';
FPSReq{7,2}='FD-60 min,CONUS-15 min,Meso-5 min';
FPSReq{8,1}='Measurement Precision';
FPSReq{8,2}='3.8 m/s';
FPSReq{9,1}='Temporal Coverage';
FPSReq{9,2}='Day/Night';
FPSReq{10,1}='Product Extent';
FPSReq{10,2}='Out to 62 Deg LZA';
FPSHdrs=cell(1,2);
FPSHdrs{1,1}='Derived Wind Data';
FPSHdrs{1,2}='Specification';
% Set some flags

import mlreportgen.dom.*;
import mlreportgen.report.*;
import mlreportgen.utils.*
% Create the report
%     eval(['cd ' pdfpath(1:length(pdfpath)-1)]);
%     rpt = Report(pdffilename,"pdf");
%     open(rpt);
%     rptstr1=strcat('////PDF file created for this run is-',pdffilename,'.pdf ////');
%     fprintf(fid,'%s\n',rptstr1);
%     rptstr2=strcat('PDF report can be found at-',pdfpath);
%     fprintf(fid,'%s\n',rptstr2);
%     rpt.Layout.Landscape = true;
%     pageLayoutObj = PDFPageLayout;
%     pageLayoutObj.PageSize.Orientation = "landscape";
%     pageLayoutObj.PageSize.Height = "8.5in";
%     pageLayoutObj.PageSize.Width = "11in";
%     pageLayoutObj.PageMargins.Top = "0.5in";
%     pageLayoutObj.PageMargins.Bottom = "0.5in";
%     pageLayoutObj.PageMargins.Left = "0.5in";
%     pageLayoutObj.PageMargins.Right = "0.5in";
%     pageLayoutObj.PageMargins.Header = "0.3in";
%     pageLayoutObj.PageMargins.Footer = "0.3in";
%     add(rpt,pageLayoutObj)
    eval(['cd ' govjpegpath(1:length(govjpegpath)-1)]);
% add a title page
%     tp = TitlePage();
%     tp.Title = 'GOES-16 Data Analysis Report';
%     tp.Subtitle = 'User Selected GOES Data';
%     tp.Image = which('GOES-Logo.jpg');
%     tp.Author = 'Stephen Forczyk';
%     tp.Publisher = 'FRC';
%     tp.PubDate = date();
%     add(rpt,tp);
%     tocc = TableOfContents;
%     tocc.Title = Text('Table of Contents');
%     tocc.Title.Color = 'blue';
%     tocc.TOCObj.NumberOfLevels = 2; 
%     add(rpt,tocc);
% Create a Chapter  with general program information
    chapter = Chapter("Title", "GOES-16 Aerosol Detection Product");
    chapter.Layout.Landscape = true;
% Abstract Section
    add(chapter,Section('Abstract'));
    parastr1='This section describes the algorithm used by GOES-16 to produce the Aerosol/SmokeDust mask also known as the ADP.';
    parastr2='The ADP will be created over land and water using observations made by the ABI sensor.';
    parastr3=strcat('Smoke and dust events affect the quality of the atmosphere and thus impact both health and the economy and thus serve as the reason',...
        ' ','to create this product.');
    parastr4='GOES-16 can,using the ABI sensor produce scans of CONUS at 5 minute intervals with resolutions ranging from 0.5 to 2.0 km.';
    parastr9=strcat(parastr1,parastr2,parastr3,parastr4);
    p1 = Paragraph(parastr9);
    p1.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p1);
    parastr11='The Aerosol detection algorithm makes use of the fact that smoke and dust clouds have observable features that differ from clouds,surface and clear sky pixels.';
    parastr12='Fundamental observables include spectral reflectance and contrast using visible and IR band data that can be obtained from the ABI sensor.';
    parastr13='The basic idea is to create threshold tests that can serve to separate out pixels that do exhibit particulate contamination from other types of pixels.';
    parastr14='Experience has shown that the visible bands produce useful difference in scene reflectance or radiance while the IR bands allow the calculation of Bright Temps.';
    parastr15='The document that serves as reference for this section is "ABI Aerosol Detection Product-Rev 3".';
    parastr16='It can be located at https://www.goes-r.gov/resources/docs.html .';
    parastr19=strcat(parastr11,parastr12,parastr13,parastr14,parastr15,parastr16);
    p2 = Paragraph(parastr19);
    p2.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p2);
    add(chapter,Section('Aerosol Product Mission Requirements'));  
%   show image with Aerosol Detection Requirements taken from Ref document    
    ExternalLink('https://www.mathworks.com/','MathWorks');
    add(chapter,ExternalLink);
    imdata = imread('GOES-Mission-Rqmts-Aerosol-Detection.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('GOES-Mission-Rqmts-Aerosol-Detection.jpg');
    text = Text('Aerosol Detection Requirements');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/1.5),'px');
    widthstr=strcat(num2str(nwid/1.5),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
    parastr31='This table shows the primary requirements needed for the GOES platform to return data for the ADP.';
    parastr32='The 3 rows of data correspond to the Conus (C),Full Disk (FD) or the meso (M) level products.';
    parastr39=strcat(parastr31,parastr32);
    p3 = Paragraph(parastr39);
    p3.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p3);
    ab=1;
    br = PageBreak();
    add(chapter,br);
% Show image containing detection qualifiers for Aerosol
    imdata = imread('GOES-Qualifier-For-Aerosol-Detection.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('GOES-Qualifier-For-Aerosol-Detection.jpg');
    text = Text('Aerosol Detection Qualifiers');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/1.5),'px');
    widthstr=strcat(num2str(nwid/1.5),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
    parastr41='This table shows the primary qualifiers needed for the GOES platform to return data for the ADP.';
    parastr42='The 3 rows of data correspond to the Conus (C),Full Disk (FD) or the meso (M) level products.';
    parastr49=strcat(parastr41,parastr42);
    p4 = Paragraph(parastr49);
    p4.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p4);
    br = PageBreak();
    add(chapter,br);
    imdata = imread('AerosolDetectionBands.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('AerosolDetectionBands.jpg');
    text = Text('Aerosol Detection Bands');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/2.2),'px');
    widthstr=strcat(num2str(nwid/2.2),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
    parastr51='This table above shows all the available ABI sensor wavebands and highlights the ones actually used.';
    parastr52='It will be seen that 10 of the 16 available wavebands are employed to detect dust and smoke.';
    parastr53='Detection of dust and smoke and establishing which of these are present in pixels is a difficult task.';
    parastr54='The ADP algorithm leverages the reflection data from the visible bands and the brightness temps derived from the IR bands to carry out this task.';
    parastr55='The current ADP algorithm does not make use of the temporal variability of pixels viewing aerosols but it is anticipated that a future version will.';
    parastr56='Another consideration is that the 10 wavebands that can be used do not have the same 2-km resolution,channels with better resolution aggregate their output to downsample to this value.';
    parastr57='The ADP algorithm will see data with a uniform 2 km spatial resolution regardless of the wavebands in use.';
    parastr59=strcat(parastr51,parastr52,parastr53,parastr54,parastr55,parastr56,parastr57);
    p5 = Paragraph(parastr59);
    p5.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p5);
%   Add flowchart of algorithm
    add(chapter,Section('ADP Algorithm Details'));  
    br = PageBreak();
    add(chapter,br);
    imdata = imread('ADP-Flowchart.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('ADP-Flowchart.jpg');
    text = Text('Aerosol Detection Processing Flowchart');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/2.2),'px');
    widthstr=strcat(num2str(nwid/2.2),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
    parastr61='This chart above shows the flow chart of how the Aerosol Detection Product is computed.';
    parastr62='The ADP is implimented in C++ and the output is in netCDF4 format.';
    parastr63='In order to speed execution,the executable is run over batches of data 10 lines at a time.this is not obvious from inspection of the flowchart.';
    parastr64='Examination of the chart,does show that the code is designed to run over land or sea pixels.';
    parastr69=strcat(parastr61,parastr62,parastr63,parastr64);
    p6 = Paragraph(parastr69);
    p6.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p6);
% Show Primary Input Data
    add(chapter,Section('ADP Primary Input Data'));  
    br = PageBreak();
    add(chapter,br);
    imdata = imread('ADP-Primary-Input-Data.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('ADP-Primary-Input-Data.jpg');
    text = Text('ADP Algorithm Primary Data Input Data');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/1.2),'px');
    widthstr=strcat(num2str(nwid/1.2),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
    parastr71='This chart above shows the input data needed for the ADP algorithm.';
    parastr72='The first 6 rows details which channels provide reflectance data.';
    parastr73='Brightness Temperature (BT) data is taken from the channel listed in the next 4 rows.';
    parastr74='The rest of the rows show where other needed data such as the solar zenith angle and quality flag data are obtained.';
    parastr79=strcat(parastr71,parastr72,parastr73,parastr74);
    p7 = Paragraph(parastr79);
    p7.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p7);
%     image.ScaleToFit=0;
%     add(chapter,image); 
%     br = PageBreak();
%     add(chapter,br);
%     add(chapter,Section('GOES ABI Wavebands'));
%     tbl_data2=(GoesWaveBandTable);
%     tbl=Table(tbl_data2);
%     tbl.TableEntriesStyle = {BackgroundColor('white')};
%     tbl.Style = [tbl.Style {Border('solid','black','3px')}];
%     tbl.ColSep = 'single';
%     tbl.RowSep = 'single';
%     tbl.HAlign='center';
%     r = row(tbl,1);
%     r.Style = [r.Style {Color('red'),Bold(true)}];
%     bt = BaseTable(tbl);
%     tabletitle = Text('GOES Waveband Table');
%     tabletitle.Bold = false;
%     bt.Title=tabletitle;
%     bt.TableWidth="7in";
%     add(chapter,bt);
%     parastr1='The table above shows the 16 wavebands that are used by the GOES-16 ABI Imager';
%     parastr2a='The Advanced Baseline Imager, manufactured by Harris Corporation, is a multi-spectral imaging'; 
%     parastr2b=' radiometer  for  the  GOES-R  series  of  satellites.  It  provides  nearly  continuous  imagery';
%     parastr2c=' of  the Western  Hemisphere from  geostationary  orbit  for  weather  prediction  and  other  Earth';
%     parastr2d=' science applications. ABI measures Earth???s radiance in 16 spectral channels ranging from visible (0.47??m)';
%     parastr2e=' to longwave infrared (13.3 ??m).';
%     parastr2=strcat(parastr2a,parastr2b,parastr2c,parastr2d,parastr2e);
%     %p1 = Paragraph("This is a paragraph with a bottom outer margin of 50pt.");
%     p1 = Paragraph(parastr2);
%     p1.Style = {OuterMargin("0pt", "0pt","50pt","10pt")};
%     add(chapter,p1);
%     add(chapter,Section('GOES ABI Coverage'));
%     imdata = imread('GOES-16-ABI-Coverage.jpg');
%     [nhigh,nwid,ndepth]=size(imdata);
%     image = mlreportgen.report.FormalImage();
%     image.Image = which('GOES-16-ABI-Coverage.jpg');
%     text = Text('GOES-16 ABI Full Disk/Conus/Meso Coverage Areas');
%     text.Color = 'red';
%     image.Caption = text;
%     heightstr=strcat(num2str(nhigh/2),'px');
%     widthstr=strcat(num2str(nwid/2),'px');
%     image.Height = heightstr;
%     image.Width = widthstr;
%     image.ScaleToFit=0;
%     add(chapter,image); 
%     parastr1='The ABI imager can operate in 3 modes-Full Disk/Conus/Meso. The first mode covers nearly one hemisphere,the second is';
%     parastr2=' focussed on the US and the Meso mode covers about a 1000x1000 Km box. The Full Disk mode is the most resource intensive,';
%     parastr3=' while the Conus mode is most useful and the Meso mode is intended to focus on areas of interest.';
%     parastr4=' Note that the pixel footprint on the earth increases with distance from the GOES platform nadir point-thus resolution is worse';
%     parastr5=' near the edges of any image. In general the resolution is poor above/below 54 Latitude.';
%     parastr6=strcat(parastr1,parastr2,parastr3,parastr4,parastr5);
%     p1 = Paragraph(parastr6);
%     p1.Style = {OuterMargin("0pt", "0pt","50pt","10pt")};
%     add(chapter,p1);
% % Add data on the GLM sensor
%     add(chapter,Section('GOES GLM Sensor'));
%     imdata = imread('GLM-Description.jpg');
%     [nhigh,nwid,ndepth]=size(imdata);
%     image = mlreportgen.report.FormalImage();
%     image.Image = which('GLM-Description.jpg');
%     text = Text('Basic Data on the GLM Sensors');
%     text.Color = 'red';
%     image.Caption = text;
%     heightstr=strcat(num2str(nhigh/1.5),'px');
%     widthstr=strcat(num2str(nwid/1.5),'px');
%     image.Height = heightstr;
%     image.Width = widthstr;
%     image.ScaleToFit=0;
%     add(chapter,image);
% % Add data on Space Weather Instruments
%     add(chapter,Section('GOES Space Weather Instruments'));
%     imdata = imread('SpaceWeatherInstruments.jpg');
%     [nhigh,nwid,ndepth]=size(imdata);
%     image = mlreportgen.report.FormalImage();
%     image.Image = which('SpaceWeatherInstruments.jpg');
%     text = Text('Basic Data On Space Weather Instruments');
%     text.Color = 'red';
%     image.Caption = text;
%     heightstr=strcat(num2str(nhigh/1.5),'px');
%     widthstr=strcat(num2str(nwid/1.5),'px');
%     image.Height = heightstr;
%     image.Width = widthstr;
%     image.ScaleToFit=0;
%     add(chapter,image);
% % add chapter to report
%     add(rpt, chapter);
% % Create a chapter to describe the Derived Winds Calculation Process
%     chapter = Chapter("Title", "Derived Winds Calculation");
%     chapter.Layout.Landscape = true;
%     add(chapter,Section('Derived Winds General Facts'));
%     parastr1='A key capability of the GOES series satellites is the ability to derive wind velocities.';
%     parastr2=strcat('In order to perform this calculation,data from the ABI imager is used with 3 consecutive image frames',...
%         ' along with a feature tracking procedure to calculate the wind velocity and direction and an altitude estimate.');
%     parastr10=strcat(parastr1,parastr2);
%     p10 = Paragraph(parastr10);
%     p10.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
%     add(chapter,p10);
%     br = PageBreak();
%     add(chapter,br);
%     tbl_header = {'Item' 'Run Time-sec'};
%     T4=[DMWDHdrs;DMWDTable1];
%     tbl4=Table(T4);
%     tbl4.Style = [tbl4.Style {Border('solid','black','3px')}];
%     tbl4.TableEntriesHAlign = 'center';
%     tbl4.HAlign='center';
%     tbl4.ColSep = 'single';
%     tbl4.RowSep = 'single';
%     tb14.TableEntriesHAlign='middle';
%     r = row(tbl4,1);
%     r.Style = [r.Style {Color('red'),Bold(true)}];
%     bt4 = BaseTable(tbl4);
%     tabletitle = Text('GOES Bands Applicable To Derived Motion Winds');
%     tabletitle.Bold = false;
%     bt4.Title = tabletitle;
%     bt4.TableWidth="7in";
%     add(chapter,bt4);
%     add(chapter,Section('Derived Winds Specification'));
%     br = PageBreak();
%     add(chapter,br);
%     tbl_header = {'Item' 'Run Time-sec'};
%     T5=[FPSHdrs;FPSReq];
%     tbl5=Table(T5);
%     tbl5.Style = [tbl5.Style {Border('solid','black','3px')}];
%     tbl5.TableEntriesHAlign = 'center';
%     tbl5.HAlign='center';
%     tbl5.ColSep = 'single';
%     tbl5.RowSep = 'single';
%     r = row(tbl5,1);
%     r.Style = [r.Style {Color('red'),Bold(true)}];
%     bt5 = BaseTable(tbl5);
%     tabletitle = Text('Derived Motion Winds Algorithm Specification');
%     tabletitle.Bold = false;
%     bt5.Title = tabletitle;
%     bt5.TableWidth="7in";
%     add(chapter,bt5);
    add(rpt,chapter);
    ab=2;
end

