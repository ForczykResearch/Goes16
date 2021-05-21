function  [outstr]=RemoveUnderScores(instr)
% Remove underscores from a text string and replace with dashes
% if this is not done the text string if shown in a plot can become
% illegible
% Written: By Stephen Forczyk
% Created: Jan 12,2012
% Revised: April 27,2015 added help
% Input Arguments:
%    instr - input string
% Output:
%    outstr = output string which is created to searching the 
%    input string and substituting dashes for any underscores found
% Notes: This routine is simply to make strings more legible in plots
%        where underscores are in the original string. Note that the
%        original instr should not be cahnged to the outstr in the calling
%        routine as this will invalidate the filename. The outstr should
%        only be used in text strings being used in plots
inval=double(instr);
outval=inval;
[ibad]=find(inval==95);
numbad=length(ibad);
if(numbad>0)
    for n=1:numbad
        ind=ibad(n);
        outval(ind)=45;
    end
end
outstr=char(outval);