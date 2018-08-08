function LC08_meta = L8_metaData(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   LC08L1TP218014201806202018070301T1MTL = IMPORTFILE(FILENAME) Reads data
%   from text file FILENAME for the default selection.
%
%   LC08L1TP218014201806202018070301T1MTL = IMPORTFILE(FILENAME, STARTROW,
%   ENDROW) Reads data from rows STARTROW through ENDROW of text file
%   FILENAME.
%
% Example:
%   LC08L1TP218014201806202018070301T1MTL = importfile('LC08_L1TP_218014_20180620_20180703_01_T1_MTL.txt', 1, 225);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2018/08/08 13:06:49

%% Initialize variables.
delimiter = ' ';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% Format for each line of text:
%   column1: text (%q)
%	column2: categorical (%C)
%   column3: categorical (%C)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%q%C%C%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
LC08_meta = table(dataArray{1:end-1}, 'VariableNames', {'GROUP','VarName2','L1_METADATA_FILE'});

