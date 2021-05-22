function UpdateMessageBox(msgstr,handles)
% This function will update the message box with a new line of text
% Written By: Stephen Forczyk
% Created: Sept 15,2016
% Revised:-------
% Classification: Unclassified

global ListBoxText ListIndex;

ListIndex=ListIndex+1;
ListBoxText{ListIndex,1}=msgstr;
set(handles.message_box,'String',ListBoxText);
set(handles.message_box,'Value',ListIndex);
drawnow;

end

