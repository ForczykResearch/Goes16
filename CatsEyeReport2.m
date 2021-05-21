import mlreportgen.report.*
import mlreportgen.dom.*
rpt = Report('output','pdf');
chapter = Chapter();
chapter.Title = 'Formal Image Reporter Example';
image = FormalImage();
image.Image = which('ngc6543a.jpg');
image.Height = '5in';
para = Paragraph('System Design Description');
para.Style = {HAlign('left'),FontFamily('Arial'),...
FontSize('12pt'),Color('white'),...
BackgroundColor('blue'), ...
OuterMargin('0in', '0in','.5in','1in')};
image.Caption = para;
add(chapter,image);
add(rpt,chapter);
rptview(rpt);