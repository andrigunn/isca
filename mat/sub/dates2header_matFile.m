function data = dates2header_matFile(data)
% Read in data structure from dir function and add time and date
% information to the structure

for i = 1:length(data);
    mod_date = data(i).name;
    HDF_DATE = mod_date(9:15);
    
    date_on_graph = num2str(HDF_DATE);
    year = date_on_graph(1,1:4);
    doy= date_on_graph(1,5:end);
    dv = datenum(year,'yyyy');
    MOD_DATE_NUM(i,1) = dv-1+str2num(doy);
    MOD_DATE_STR(i,:) = time_builder(MOD_DATE_NUM(i,1));
    
    [data(i).year] = MOD_DATE_STR(i,1);
    [data(i).month] = MOD_DATE_STR(i,2);
    [data(i).day] = MOD_DATE_STR(i,3);
    [data(i).hour] = MOD_DATE_STR(i,4);
    [data(i).second] = MOD_DATE_STR(i,5);
    [data(i).doy] = MOD_DATE_STR(i,6);
    [data(i).daten] = MOD_DATE_STR(i,7);
end

data = rmfield(data, 'date');
data = rmfield(data, 'isdir');
data = rmfield(data, 'bytes');
data = rmfield(data, 'datenum');
