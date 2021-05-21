% Import report API classes (optional)
import mlreportgen.report.*

% Add report container (required)
rpt = Report('output','pdf');

% Add content to container (required)
% Types of content added here: title 
% page and table of contents reporters
titlepg = TitlePage;
titlepg.Title = 'My Airplane';
titlepg.Author = 'Pilot A';
add(rpt,titlepg);
add(rpt,TableOfContents);

% Add content to report sections (optional)
% Text and formal image added to chapter
chap = Chapter('Plane Image');
add(chap,'Here is the plane:');
add(chap,FormalImage('Image',...
    which('b747.jpg'),'Height','5in',...
    'Width','5in','Caption','Boeing 747'));
add(rpt,chap);

% Close the report (required)
close(rpt);
% Display the report (optional)
rptview(rpt);