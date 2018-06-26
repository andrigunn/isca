function [missing_dates first_day last_day] = Modis_QAQC(data)
%% Checks and errors
% Missing dates is a structure with dates that are missing
% first day and last day are the dates of the first and last in the data
% structure input
% equal_length is 1 if no 
% Check for unique values in data structure, i.e. no dates two times
clc
%% Check if dates are continous, from and to what range
first_day = data(1).daten;                                    % First day in data structure
last_day = data(end).daten;                                   % Last day in data structure
no_days = [first_day:1:last_day];                             % Real number of days
missing_dates =  setdiff(no_days,[data.daten])';              % Find differnce in dates    
missing_dates = time_builder(missing_dates);
