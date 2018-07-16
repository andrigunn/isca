function L8_data_structure = L8_read_txt_file(filename, startRow, endRow)


%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';

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

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,5,6,7,8,9,10,12,18,19,20,21,22,23,24,25,27,28,30,32,33,34,35,36,37,39,40,41,42,43,44,59,60,61,62,63,64,65,66,67,68]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end


%% Split data into numeric and string columns.
rawNumericColumns = raw(:, [1,5,6,7,8,9,10,12,18,19,20,21,22,23,24,25,27,28,30,32,33,34,35,36,37,39,40,41,42,43,44,59,60,61,62,63,64,65,66,67,68]);
rawStringColumns = string(raw(:, [2,3,4,11,13,14,15,16,17,26,29,31,38,45,46,47,48,49,50,51,52,53,54,55,56,57,58,69,70,71]));


%% Make sure any text containing <undefined> is properly converted to an <undefined> categorical
for catIdx = [3,4,5,8,9,10,11,12,13,14,15,16,17,18]
    idx = (rawStringColumns(:, catIdx) == "<undefined>");
    rawStringColumns(idx, catIdx) = "";
end

%% Create output variable
LANDSAT8C1265943 = table;
LANDSAT8C1265943.ResultNumber = cell2mat(rawNumericColumns(:, 1));
LANDSAT8C1265943.LandsatProductIdentifier = rawStringColumns(:, 1);
LANDSAT8C1265943.LandsatSceneIdentifier = rawStringColumns(:, 2);
LANDSAT8C1265943.AcquisitionDate = categorical(rawStringColumns(:, 3));
LANDSAT8C1265943.CollectionCategory = cell2mat(rawNumericColumns(:, 2));
LANDSAT8C1265943.CollectionNumber = cell2mat(rawNumericColumns(:, 3));
LANDSAT8C1265943.WRSPath = cell2mat(rawNumericColumns(:, 4));
LANDSAT8C1265943.WRSRow = cell2mat(rawNumericColumns(:, 5));
LANDSAT8C1265943.TargetWRSPath = cell2mat(rawNumericColumns(:, 6));
LANDSAT8C1265943.TargetWRSRow = cell2mat(rawNumericColumns(:, 7));
LANDSAT8C1265943.NadirOffNadir = categorical(rawStringColumns(:, 4));
LANDSAT8C1265943.RollAngle = cell2mat(rawNumericColumns(:, 8));
LANDSAT8C1265943.DateL1Generated = categorical(rawStringColumns(:, 5));
LANDSAT8C1265943.StartTime = rawStringColumns(:, 6);
LANDSAT8C1265943.StopTime = rawStringColumns(:, 7);
LANDSAT8C1265943.StationIdentifier = categorical(rawStringColumns(:, 8));
LANDSAT8C1265943.DayNightIndicator = categorical(rawStringColumns(:, 9));
LANDSAT8C1265943.LandCloudCover = cell2mat(rawNumericColumns(:, 9));
LANDSAT8C1265943.SceneCloudCover = cell2mat(rawNumericColumns(:, 10));
LANDSAT8C1265943.GroundControlPointsModel = cell2mat(rawNumericColumns(:, 11));
LANDSAT8C1265943.GroundControlPointsVersion = cell2mat(rawNumericColumns(:, 12));
LANDSAT8C1265943.GeometricRMSEModelmeters = cell2mat(rawNumericColumns(:, 13));
LANDSAT8C1265943.GeometricRMSEModelX = cell2mat(rawNumericColumns(:, 14));
LANDSAT8C1265943.GeometricRMSEModelY = cell2mat(rawNumericColumns(:, 15));
LANDSAT8C1265943.ImageQuality = cell2mat(rawNumericColumns(:, 16));
LANDSAT8C1265943.ProcessingSoftwareVersion = categorical(rawStringColumns(:, 10));
LANDSAT8C1265943.SunElevationL1 = cell2mat(rawNumericColumns(:, 17));
LANDSAT8C1265943.SunAzimuthL1 = cell2mat(rawNumericColumns(:, 18));
LANDSAT8C1265943.TIRSSSMModel = categorical(rawStringColumns(:, 11));
LANDSAT8C1265943.DataTypeLevel1 = cell2mat(rawNumericColumns(:, 19));
LANDSAT8C1265943.SensorIdentifier = categorical(rawStringColumns(:, 12));
LANDSAT8C1265943.PanchromaticLines = cell2mat(rawNumericColumns(:, 20));
LANDSAT8C1265943.PanchromaticSamples = cell2mat(rawNumericColumns(:, 21));
LANDSAT8C1265943.ReflectiveLines = cell2mat(rawNumericColumns(:, 22));
LANDSAT8C1265943.ReflectiveSamples = cell2mat(rawNumericColumns(:, 23));
LANDSAT8C1265943.ThermalLines = cell2mat(rawNumericColumns(:, 24));
LANDSAT8C1265943.ThermalSamples = cell2mat(rawNumericColumns(:, 25));
LANDSAT8C1265943.MapProjectionLevel1 = categorical(rawStringColumns(:, 13));
LANDSAT8C1265943.UTMZone = cell2mat(rawNumericColumns(:, 26));
LANDSAT8C1265943.Datum = cell2mat(rawNumericColumns(:, 27));
LANDSAT8C1265943.Ellipsoid = cell2mat(rawNumericColumns(:, 28));
LANDSAT8C1265943.GridCellSizePanchromatic = cell2mat(rawNumericColumns(:, 29));
LANDSAT8C1265943.GridCellSizeReflective = cell2mat(rawNumericColumns(:, 30));
LANDSAT8C1265943.GridCellSizeThermal = cell2mat(rawNumericColumns(:, 31));
LANDSAT8C1265943.BiasParameterFileNameOLI = categorical(rawStringColumns(:, 14));
LANDSAT8C1265943.BiasParameterFileNameTIRS = categorical(rawStringColumns(:, 15));
LANDSAT8C1265943.CalibrationParameterFile = categorical(rawStringColumns(:, 16));
LANDSAT8C1265943.RLUTFileName = categorical(rawStringColumns(:, 17));
LANDSAT8C1265943.CenterLatitude = categorical(rawStringColumns(:, 18));
LANDSAT8C1265943.CenterLongitude = rawStringColumns(:, 19);
LANDSAT8C1265943.ULCornerLat = rawStringColumns(:, 20);
LANDSAT8C1265943.ULCornerLong = rawStringColumns(:, 21);
LANDSAT8C1265943.URCornerLat = rawStringColumns(:, 22);
LANDSAT8C1265943.URCornerLong = rawStringColumns(:, 23);
LANDSAT8C1265943.LLCornerLat = rawStringColumns(:, 24);
LANDSAT8C1265943.LLCornerLong = rawStringColumns(:, 25);
LANDSAT8C1265943.LRCornerLat = rawStringColumns(:, 26);
LANDSAT8C1265943.LRCornerLong = rawStringColumns(:, 27);
LANDSAT8C1265943.CenterLatitudedec = cell2mat(rawNumericColumns(:, 32));
LANDSAT8C1265943.CenterLongitudedec = cell2mat(rawNumericColumns(:, 33));
LANDSAT8C1265943.ULCornerLatdec = cell2mat(rawNumericColumns(:, 34));
LANDSAT8C1265943.ULCornerLongdec = cell2mat(rawNumericColumns(:, 35));
LANDSAT8C1265943.URCornerLatdec = cell2mat(rawNumericColumns(:, 36));
LANDSAT8C1265943.URCornerLongdec = cell2mat(rawNumericColumns(:, 37));
LANDSAT8C1265943.LLCornerLatdec = cell2mat(rawNumericColumns(:, 38));
LANDSAT8C1265943.LLCornerLongdec = cell2mat(rawNumericColumns(:, 39));
LANDSAT8C1265943.LRCornerLatdec = cell2mat(rawNumericColumns(:, 40));
LANDSAT8C1265943.LRCornerLongdec = cell2mat(rawNumericColumns(:, 41));
LANDSAT8C1265943.DisplayID = rawStringColumns(:, 28);
LANDSAT8C1265943.OrderingID = rawStringColumns(:, 29);
LANDSAT8C1265943.BrowseLink = rawStringColumns(:, 30);

L8_data_structure = LANDSAT8C1265943

