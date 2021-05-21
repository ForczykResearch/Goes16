global pdfpath
pdfpath='D:\Goes16\Imagery\Aug26_2020\PDF_Files\';
import mlreportgen.report.*
eval(['cd ' pdfpath(1:length(pdfpath)-1)]);
rpt = mlreportgen.report.Report('CatEyeExample','pdf');
chapter = mlreportgen.report.Chapter(); 
chapter.Title = 'Formal Image Reporter Example';
imdata = imread('ngc6543a.jpg');
[nhigh,nwid,ndepth]=size(imdata);
image = mlreportgen.report.FormalImage();
image.Image = which('ngc6543a.jpg');
text = Text('Cat''s Eye Nebula or NGC 6543');
text.Color = 'red';
image.Caption = 'Cat''s Eye Nebula or NGC 6543';
heightstr=strcat(num2str(nhigh),'px');
widthstr=strcat(num2str(nwid),'px');
% image.Height = '300px';
% image.Width = '400px';
image.Height = heightstr;
image.Width = widthstr;
image.ScaleToFit=0;
add(chapter,image); 
add(rpt,chapter);
rptview(rpt);
close(rpt)