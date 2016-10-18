% %read rainfall data from columbia
clear all
close all
% 
% %source Noaa Cmorph
% %starting date 23 Feb 2005
% url='http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP/.CPC/.CMORPH/.daily/.mean/.microwave-only/.comb/T/0.0/2890./RANGE/X/285.25/292./RANGEEDGES/Y/17.25/20.5/RANGEEDGES/dods';
% 
% date_list_noaa=datenum('23.02.2005','dd.mm.yyyy')+ncread(url,'T');
% X_noaa=ncread(url,'X');
% Y_noaa=ncread(url,'Y');
% noaa_Y_X_day=double(ncread(url,'comb'));
% noaa_Y_X_day(noaa_Y_X_day==-9999)=NaN;
% noaa_Y_X_day=noaa_Y_X_day*24;   %from mm/h to mm/day
% 
% return
% 
% 
% for t=1:length(date_list_noaa)
%     pcolor(X_noaa,Y_noaa,noaa_Y_X_day(:,:,t))
%     set(gca,'Clim',[0 10])
%     shading flat
%     axis equal
%     title(datestr(date_list_noaa(t)),'fontsize',12);
%     colorbar
%     axis off
%     getframe
% end
% 
% return
% 
% noaa_day=squeeze(nanmean(nanmean(noaa_Y_X_day),2));
% figure(100)
% plot(date_list_noaa,noaa_day)
% hold on
% 
% 
% iii=find(date_list_noaa==datenum('01.01.2011','dd.mm.yyyy'));
% 
% noaa_day_2011=noaa_day(iii:end);
% noaa_day_2011=noaa_day_2011(1:700);
% noaa_decadal_2011=mean(reshape(noaa_day_2011,10,70));
% noaa_decadal_2011=repmat(noaa_decadal_2011,100,1)
% noaa_decadal_2011=noaa_decadal_2011(:)

% return

%source NASA TRMM
%starting date 1 Jan 1998

url='http://iridl.ldeo.columbia.edu/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42RT/.v7/.daily/.precipitation/X/%2874.625W%29%2868.125W%29RANGEEDGES/Y/%2817.375N%29%2820.125N%29RANGEEDGES/dods';

date_list_nasa=double(datenum('01.01.1998','dd.mm.yyyy')+ncread(url,'T'));
X_nasa=ncread(url,'X');
Y_nasa=ncread(url,'Y');
nasa_X_Y_day=double(ncread(url,'precipitation')); %units: mm/day
nasa_X_Y_day(nasa_X_Y_day==-9999)=NaN;


% 
% for t=1:length(date_list_nasa)
%     pcolor(X_nasa,Y_nasa,nasa_Y_X_day(:,:,t))
%     shading interp
%     set(gca,'Clim',[0 10])
%     shading flat
%     axis equal
%     title(datestr(date_list_nasa(t)),'fontsize',12);
%     colorbar
%     axis off
%     getframe
% end

nasa_day=squeeze(nanmean(nanmean(nasa_X_Y_day),2));
figure(100)
plot(date_list_nasa,nasa_day,'-r')
datetick('x')

save prec_nasa_7Oct2016