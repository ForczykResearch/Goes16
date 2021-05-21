import mlreportgen.report.*
import mlreportgen.dom.*

rpt = Report('Report with TOC');
add(rpt, TitlePage('Title','Report','Subtitle','with TOC'));
toc = TableOfContents;
toc.Title = Text('Table of Contents');
toc.Title.Color = 'green';
toc.TOCObj.NumberOfLevels = 2; 
add(rpt,toc);

ch = Chapter('First Chapter');
add(ch,Section('First Subsection'));
add(ch,Section('Second Subsection'));

add(rpt,ch);
add(rpt,Chapter('Second Chapter'));

add(rpt,PDFPageLayout);
% p = Paragraph('Appendix'); 
% p.Style = {OutlineLevel(1), Bold, FontSize('18pt')};
% add(rpt,p);

close(rpt);
rptview(rpt);