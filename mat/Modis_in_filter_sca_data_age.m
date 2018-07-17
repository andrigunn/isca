function [data_age_groups] = Modis_in_filter_sca_data_age(unfilter_data, in, end_day, Center_date)

%% Lesum inn in skrá með indexum fyrir gildi sem við viljum eyða út.
%% Input
% 2400 x 2400 Modis tile file
% In (1/0) file with ins to calcluate for. In Mask on the same grid as the Modis
% tile


%% Output
%

%% FOR TESTING
unfilter_data = Data_stacked_age;
in = ins.in_isl;


k = find(in==1);
filter_data = unfilter_data(k);

%filter_average = nanmean(nanmean(filter_data));

no_el_in = size(k); no_el_in = no_el_in(1) ;

for i = 1:end_day
    no_el_data = sum(filter_data(:) == (i-Center_date))/no_el_in;
    data_age_groups(:,i) = [i,no_el_data]
       
end
%%
sum(data_age_groups())
%%
checksum = no_el_clouds + no_el_data;

if checksum == no_el_in;
    csum = 1;
else
    csum = 0;
end

prct_data_in   =  no_el_data/no_el_in;
prct_clouds_in =  no_el_clouds/no_el_in;
checksum2 = prct_data_in+prct_clouds_in;

if checksum2 == 1;
    csum2 = 1;
else
    csum2 = 0;
end
%%
