% This routine is to test inserting a pagebreak before a table
global GoesWaveBand GoesWaveBand2 GoesWaveBandTable;
import mlreportgen.dom.*;
import mlreportgen.report.*;
import mlreportgen.utils.*
% Set up cell to hold generic GOES Waveband Data
GoesWaveBand=cell(17,5);
GoesWaveBand{1,1}='Band Num';
GoesWaveBand{1,2}='Resolution-km';
GoesWaveBand{1,3}='Wavelength-microns';
GoesWaveBand{1,4}='Spectrum';
GoesWaveBand{1,5}='Band Desc';
GoesWaveBand{2,1}=1;
GoesWaveBand{2,2}=1;
GoesWaveBand{2,3}=0.47;
GoesWaveBand{2,4}='Visible';
GoesWaveBand{2,5}='Blue Band';
GoesWaveBand{3,1}=2;
GoesWaveBand{3,2}=0.5;
GoesWaveBand{3,3}=0.64;
GoesWaveBand{3,4}='Visible';
GoesWaveBand{3,5}='Red Band';
GoesWaveBand{4,1}=3;
GoesWaveBand{4,2}=1;
GoesWaveBand{4,3}=0.86;
GoesWaveBand{4,4}='Near IR';
GoesWaveBand{4,5}='Red Band';
GoesWaveBand{5,1}=4;
GoesWaveBand{5,2}=2;
GoesWaveBand{5,3}=1.37;
GoesWaveBand{5,4}='Near-IR';
GoesWaveBand{5,5}='Cirrus Band';
GoesWaveBand{6,1}=5;
GoesWaveBand{6,2}=1;
GoesWaveBand{6,3}=1.60;
GoesWaveBand{6,4}='Near-IR';
GoesWaveBand{6,5}='Snow/Ice Band';
GoesWaveBand{7,1}=6;
GoesWaveBand{7,2}=2;
GoesWaveBand{7,3}=2.24;
GoesWaveBand{7,4}='Near-IR';
GoesWaveBand{7,5}='Cloud Particle Band';
GoesWaveBand{8,1}=7;
GoesWaveBand{8,2}=2;
GoesWaveBand{8,3}=3.90;
GoesWaveBand{8,4}='IR';
GoesWaveBand{8,5}='Short Wave Window Band';
GoesWaveBand{9,1}=8;
GoesWaveBand{9,2}=2;
GoesWaveBand{9,3}=6.20;
GoesWaveBand{9,4}='IR';
GoesWaveBand{9,5}='Upper Troposphere WV Band';
GoesWaveBand{10,1}=9;
GoesWaveBand{10,2}=2;
GoesWaveBand{10,3}=6.90;
GoesWaveBand{10,4}='IR';
GoesWaveBand{10,5}='Mid Level Troposphere WV Band';
GoesWaveBand{11,1}=10;
GoesWaveBand{11,2}=2;
GoesWaveBand{11,3}=7.30;
GoesWaveBand{11,4}='IR';
GoesWaveBand{11,5}='Low Level Troposphere WV Band';
GoesWaveBand{12,1}=11;
GoesWaveBand{12,2}=2;
GoesWaveBand{12,3}=8.40;
GoesWaveBand{12,4}='IR';
GoesWaveBand{12,5}='Cloud Top Phase Band';
GoesWaveBand{13,1}=12;
GoesWaveBand{13,2}=2;
GoesWaveBand{13,3}=9.60;
GoesWaveBand{13,4}='IR';
GoesWaveBand{13,5}='Ozone Band';
GoesWaveBand{14,1}=13;
GoesWaveBand{14,2}=2;
GoesWaveBand{14,3}=10.30;
GoesWaveBand{14,4}='IR';
GoesWaveBand{14,5}='Clean IR Longwave Band';
GoesWaveBand{15,1}=14;
GoesWaveBand{15,2}=2;
GoesWaveBand{15,3}=11.20;
GoesWaveBand{15,4}='IR';
GoesWaveBand{15,5}='IR Longwave Band';
GoesWaveBand{16,1}=15;
GoesWaveBand{16,2}=2;
GoesWaveBand{16,3}=12.30;
GoesWaveBand{16,4}='IR';
GoesWaveBand{16,5}='Dirty IR Longwave Band';
GoesWaveBand{17,1}=16;
GoesWaveBand{17,2}=2;
GoesWaveBand{17,3}=13.30;
GoesWaveBand{17,4}='IR';
GoesWaveBand{17,5}='CO2 IR Longwave Band';
GoesWaveBand2=cell(16,5);
for j=2:17
    for k=1:5
        if(k~=3)
            GoesWaveBand2{j-1,k}=GoesWaveBand{j,k};
        else
            nowVal=GoesWaveBand{j,k};
            nowStr=num2str(nowVal,2);
            GoesWaveBand2{j-1,k}=nowStr;
        end
    end
end
GoesWaveBandTable=cell2table(GoesWaveBand2,...
    'VariableNames',{'Band Num' 'Resolution-Km' 'Wavelength-microns' 'Spectrum' 'Band Desc'});
pdffilename='TestReport';
rpt = Report(pdffilename,"pdf");
open(rpt);
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
% d = Document('mydoc','pdf');
% open(d);
chapter = Chapter("Title", "GOES-16 Detailed Description");
chapter.Layout.Landscape = true;
% Create first page
h = Heading1('My First Head');
p = Paragraph('Here are some paragraphs.');
% append(d,h);
% append(d,p);
% append(d,clone(p));
% append(d,clone(p));
% append(d,clone(p));
% append(d,clone(p));
% append(d,clone(p));
% Create and append the page break object
  br = PageBreak();
% append(d,br);
  add(chapter,p);
  add(chapter,br);


% Create paragraphs that appear on the page after the break
p2 = Paragraph('Here are some paragraphs after the forced page break.');
add(chapter,p2);
add(chapter,br);
tbl_data2=(GoesWaveBandTable);
tbl=Table(tbl_data2);
tbl.TableEntriesStyle = {BackgroundColor('white')};
tbl.Style = [tbl.Style {Border('solid','black','3px')}];
tbl.ColSep = 'single';
tbl.RowSep = 'single';
r = row(tbl,1);
r.Style = [r.Style {Color('red'),Bold(true)}];
bt = BaseTable(tbl);
tabletitle = Text('GOES Waveband Table');
tabletitle.Bold = false;
bt.Title=tabletitle;
add(chapter,bt);
br = PageBreak();
p3 = Paragraph('Here is the third paragraph.');
add(chapter,p3);
add(rpt,chapter);
close(rpt)
rptview(rpt);