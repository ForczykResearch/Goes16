function [inFolderList] = GetSubDirsFirstLevelOnly(parentDir)
% This function was created to get a listing of just file folders contained
% on level down from the parent directory
% Written By:Paulo Abelha 
% Created: Oct 19,2018
% Source: Answer to a question on Matlab central

    % Get a list of all files and folders in this folder.
    files = dir(parentDir);
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir];
    % Extract only those that are directories.
    subDirs = files(dirFlags);
    subDirsNames = cell(1, numel(subDirs) - 2);
    for i=3:numel(subDirs)
        subDirsNames{i-2} = subDirs(i).name;
    end
% transpose names modified original code by SMF
    inFolderList=subDirsNames';
   
end