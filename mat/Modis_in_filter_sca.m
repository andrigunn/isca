function [filter_average,no_el_in,no_el_data,no_el_clouds,prct_data_in,prct_clouds_in,csum,csum2] = Modis_in_filter_sca(unfilter_data, in)

%% Lesum inn in skrá með indexum fyrir gildi sem við viljum eyða út.
%% Input
% 2400 x 2400 Modis tile file
% In (1/0) file with ins to calcluate for. In Mask on the same grid as the Modis
% tile


%% Output
% filter_average is a nan mean of all elements that have data within the in
% mask provided
% csum is the sum of pixels with data/no data compared to the input structure size reita í in skránni
% csum2 er það sama og fyrir csum nema bara með hlutfall gagna
% filter_average er meðaltal fyrir reiti þar sem eru gögn
%% FOR TESTING
% unfilter_data = MCDAT;
% in = ins.in_isl;

k = find(in==1);
filter_data = unfilter_data(k);

filter_average = nanmean(nanmean(filter_data));

no_el_in = size(k); no_el_in = no_el_in(1) ;
no_el_data = sum(filter_data(:) >= 0);
no_el_nan = size(find(isnan(filter_data)));
no_el_clouds = no_el_nan(1);
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
