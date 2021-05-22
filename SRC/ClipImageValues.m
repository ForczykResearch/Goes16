function [OutputImage,lowclip,highclip] = ClipImageValues(InputImage,lowval,highval)
% This function will clip a GOES16/17 image to values between lowval and
% highval
% Written By: Stephen Forczyk
% Created: August 22,2020
% Revised: -----
% Classification: Unclassified
lowclip=0;
highclip=0;
OutputImage=InputImage;
[rowL,colL]=find(InputImage<lowval);
a1=isempty(rowL);
if(a1~=1)
   lowclip=length(rowL); 
   for n=1:lowclip
       rowNow=rowL(n,1);
       colNow=colL(n,1);
       OutputImage(rowNow,colNow)=lowval;
   end
end
[rowH,colH]=find(InputImage>highval);
a3=isempty(rowH);
if(a3~=1)
  highclip=length(rowH); 
  for n=1:highclip
       rowNow=rowH(n,1);
       colNow=colH(n,1);
       OutputImage(rowNow,colNow)=highval;
  end
end
ab=2;
end

