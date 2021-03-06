function CreatePDFReportHeader
% This function will create the initial "boilerplate" header info
% Written By: Stephen Forczyk
% Created: Jan 01,2021
% Revised:-----
% Classification: Unclassified
global GoesWaveBand GoesWaveBand2 GoesWaveBandTable;
global NumProcFiles ProcFileList;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;

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

% Set some flags

iCreatePDFReport=1;
JpegCounter=0;
import mlreportgen.dom.*;
import mlreportgen.report.*;
import mlreportgen.utils.*
% Create the report
    eval(['cd ' pdfpath(1:length(pdfpath)-1)]);
    rpt = Report(pdffilename,"pdf");
    open(rpt);
    rptstr1=strcat('////PDF file created for this run is-',pdffilename,'.pdf ////');
    fprintf(fid,'%s\n',rptstr1);
    rptstr2=strcat('PDF report can be found at-',pdfpath);
    fprintf(fid,'%s\n',rptstr2);
    rpt.Layout.Landscape = true;
    pageLayoutObj = PDFPageLayout;
    pageLayoutObj.PageSize.Orientation = "landscape";
    pageLayoutObj.PageSize.Height = "8.5in";
    pageLayoutObj.PageSize.Width = "11in";
    pageLayoutObj.PageMargins.Top = "0.5in";
    pageLayoutObj.PageMargins.Bottom = "0.5in";
    pageLayoutObj.PageMargins.Left = "0.5in";
    pageLayoutObj.PageMargins.Right = "0.5in";
    pageLayoutObj.PageMargins.Header = "0.3in";
    pageLayoutObj.PageMargins.Footer = "0.3in";
    add(rpt,pageLayoutObj)
    eval(['cd ' govjpegpath(1:length(govjpegpath)-1)]);
% Create Chapter 1 with general program information
    chapter = Chapter("Title", "GOES-16 General Program Data");
    chapter.Layout.Landscape = true;
    imdata = imread('GOES-Mission.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('GOES-Mission.jpg');
    text = Text('GOES-16 Mission Statement');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/2),'px');
    widthstr=strcat(num2str(nwid/2),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image); 
    imdata = imread('BasicMissions.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('BasicMissions.jpg');
    text = Text('GOES-16 Basic Tasks');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/2),'px');
    widthstr=strcat(num2str(nwid/2),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image); 
    imdata = imread('GOES-SystemOverview.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('GOES-SystemOverview.jpg');
    text = Text('GOES-16 System');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/2),'px');
    widthstr=strcat(num2str(nwid/2),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image); 
    imdata = imread('GOES-Platform.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('GOES-Platform.jpg');
    text = Text('GOES-16 Observational Platform');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/2),'px');
    widthstr=strcat(num2str(nwid/2),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
    imdata = imread('GOES-Coverage.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('GOES-Coverage.jpg');
    text = Text('GOES-16/17 Satellite Locations');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/2),'px');
    widthstr=strcat(num2str(nwid/2),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image); 
    imdata = imread('GOES-DataProducts.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('GOES-DataProducts.jpg');
    text = Text('GOES-16/17 Satellite Data Products');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/2),'px');
    widthstr=strcat(num2str(nwid/2),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image); 
    add(rpt, chapter);
% Create chapter 2 with more specific data on GOES sensors
    chapter = Chapter("Title", "GOES-16 Detailed Description");
    chapter.Layout.Landscape = true;
    imdata = imread('GOES-16.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('GOES-16.jpg');
    text = Text('GOES-16 Satellite Image');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/2),'px');
    widthstr=strcat(num2str(nwid/2),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image); 
    imdata = imread('ABI-Description.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('ABI-Description.jpg');
    text = Text('GOES-16 ABI Basic Description');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/2),'px');
    widthstr=strcat(num2str(nwid/2),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image); 
% add a waveband table
    tbl_header = {'Band Num' 'Resolution-Km' 'Wavelength-microns' 'Spectrum' 'Band Desc'};
    tbl_data=GoesWaveBand2;
    formalTable = mlreportgen.dom.FormalTable(tbl_header,tbl_data);
    formalTable.RowSep = "Solid";
    formalTable.ColSep = "Solid";
    formalTable.Border = "Solid";
    formalTable.Header.TableEntriesStyle = [formalTable.Header.TableEntriesStyle,...
        {mlreportgen.dom.Bold(true)}];
    formalTable.TableEntriesStyle = [formalTable.TableEntriesStyle,...
        {mlreportgen.dom.InnerMargin("2pt","2pt","2pt","2pt"),...
        mlreportgen.dom.WhiteSpace("preserve")}];
    formalTable.TableEntriesHAlign = "center";
    add(chapter, formalTable);
    parastr1='The table above shows the 16 wavebands that are used by the GOES-16 ABI Imager';
    parastr2a='The Advanced Baseline Imager, manufactured by Harris Corporation, is a multi-spectral imaging'; 
    parastr2b=' radiometer  for  the  GOES-R  series  of  satellites.  It  provides  nearly  continuous  imagery';
    parastr2c=' of  the Western  Hemisphere from  geostationary  orbit  for  weather  prediction  and  other  Earth';
    parastr2d=' science applications. ABI measures Earth???s radiance in 16 spectral channels ranging from visible (0.47??m)';
    parastr2e=' to longwave infrared (13.3 ??m).';
    parastr2=strcat(parastr2a,parastr2b,parastr2c,parastr2d,parastr2e);
    %p1 = Paragraph("This is a paragraph with a bottom outer margin of 50pt.");
    p1 = Paragraph(parastr2);
    p1.Style = {OuterMargin("0pt", "0pt","50pt","10pt")};
    add(chapter,p1);
    imdata = imread('GOES-16-ABI-Coverage.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('GOES-16-ABI-Coverage.jpg');
    text = Text('GOES-16 ABI Full Disk/Conus/Meso Coverage Areas');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/2),'px');
    widthstr=strcat(num2str(nwid/2),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image); 
    parastr1='The ABI imager can operate in 3 modes-Full Disk/Conus/Meso. The first mode covers nearly one hemisphere,the second is';
    parastr2=' focussed on the US and the Meso mode covers about a 1000x1000 Km box. The Full Disk mode is the most resource intensive,';
    parastr3=' while the Conus mode is most useful and the Meso mode is intended to focus on areas of interest.';
    parastr4=' Note that the pixel footprint on the earth increases with distance from the GOES platform nadir point-thus resolution is worse';
    parastr5=' near the edges of any image. In general the resolution is poor above/below 54 Latitude.';
    parastr6=strcat(parastr1,parastr2,parastr3,parastr4,parastr5);
    p1 = Paragraph(parastr6);
    p1.Style = {OuterMargin("0pt", "0pt","50pt","10pt")};
    add(chapter,p1);
% Add data on the GLM sensor
    imdata = imread('GLM-Description.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('GLM-Description.jpg');
    text = Text('Basic Data on the GLM Sensors');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/1.5),'px');
    widthstr=strcat(num2str(nwid/1.5),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
% Add data on Space Weather Instruments
    imdata = imread('SpaceWeatherInstruments.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('SpaceWeatherInstruments.jpg');
    text = Text('Basic Data On Space Weather Instruments');
    text.Color = 'red';
    image.Caption = text;
    heightstr=strcat(num2str(nhigh/1.5),'px');
    widthstr=strcat(num2str(nwid/1.5),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
% add chapter to report
    add(rpt, chapter);
end

