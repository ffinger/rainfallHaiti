
clear all
close all

%source NASA TRMM
%starting date 1 Jan 1998

url='http://iridl.ldeo.columbia.edu/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42RT/.v7/.daily/.precipitation/X/%2874.625W%29%2868.125W%29RANGEEDGES/Y/%2817.375N%29%2820.125N%29RANGEEDGES/dods';

date_list_nasa=double(datenum('01.01.1998','dd.mm.yyyy')+ncread(url,'T'));
X_nasa=ncread(url,'X');
Y_nasa=ncread(url,'Y');
nasa_X_Y_day=double(ncread(url,'precipitation')); %units: mm/day
nasa_X_Y_day(nasa_X_Y_day==-9999)=NaN;

nasa_day=squeeze(nanmean(nanmean(nasa_X_Y_day),2));
figure(100)
plot(date_list_nasa,nasa_day,'-r')
datetick('x')

save prec_nasa
