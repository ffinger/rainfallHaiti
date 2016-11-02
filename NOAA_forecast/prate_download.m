%%
% 2016/02/09  Damiano Pasetto -EPFL
% program for the downolad of nooa CFS reforecast of precipitation rate and 
% interpolation over the Haiti watersheds 

% Reforecasts are performed every 5 days, from 12 Dec 1981 to 31 Mar 2011 
% Reforecasts have data for 9 months (308 days), every 6 hours.

% url: https://www.ncdc.noaa.gov/data-access/model-data/model-datasets/climate-forecast-system-version2-cfsv2

clc
close all 
clear all

load ../centroids % centroids of the communes (where we want to evaluate the precipitatio)n.
centr=centroids;

AggList=[];
%AggList=Agg_a;

max_lat=max(centr(:,2));
max_lon=max(centr(:,1));
if max_lon<0
    max_lon=max_lon+360;
end
min_lat=min(centr(:,2));
min_lon=min(centr(:,1));

if min_lon<0
    min_lon=min_lon+360;
end


% url of the precipiataion rate
Initial_date=[2016,10,15,0,0,0];  % first date for metereological data forecast
Final_date=[2016,10,23,0,0,0];    % last date available in noaa server
Initial_date_num=datenum(Initial_date);
Final_date_num=datenum(Final_date);
Tstep_date=1;                     % time among forecasts

num_date=0;
url_prefix='http://nomads.ncdc.noaa.gov/thredds/dodsC/modeldata/cfsv2_forecast_6-hourly_9mon_flxf/';
% loop on initial dates of forecast
for idate=Initial_date_num:Tstep_date:Final_date_num 
    
    tic
    num_date=num_date+1;
    iy=datestr(idate,'yyyy');
    iym=datestr(idate,'yyyymm');
    iymd=datestr(idate,'yyyymmdd');
    iymdh=datestr(idate,'yyyymmdd');
    url_idate=[iy,'/',iym,'/',iymd,'/',iymdh,'00/'];
    url_suffix=['.01.',datestr(idate,'yyyymmdd'),'00.grb2'];
    % loop on the forecasted days/hours
    nfile=0;
    file_exists=1;
    fdate=idate+0.5; %forecasted dates (every 6 hours); first date = idate+ 12h
    prate=[];
    ftime=[];
    count_d=0;
    while (file_exists==1 && count_d<60)
        count_d=count_d+1;
        data_fname=['flxf',datestr(fdate,'yyyymmddHH')];
        data_url1=[url_prefix,url_idate,data_fname,url_suffix];
        %data_url='flxf2011040206.01.2011040200.grb2
        %ncid=netcdf.open(data_url1);
        try 
            ncid=netcdf.open(data_url1);
        catch ME
            disp(ME.identifier)
            disp(data_url1)
            pause(2)
            try
                 ncid=netcdf.open(data_url1);
                 disp('second attempt')
            catch ME1
                disp(ME1.identifier)
                disp(data_url1)
                pause(5)
                try
                    ncid=netcdf.open(data_url1);
                    disp('third attempt')
                catch ME2
                    disp(ME2.identifier)
                    disp(data_url1)
                    file_exists=0; % the file to download does not exists
                    fdate=fdate-1;
                end
            end
        end
        if file_exists==1
            nfile=nfile+1;
            if mod(nfile,10)==0
               disp(['file opened: ',num2str(nfile),' time: ',num2str(fdate-idate)])
            end
            % inquire file properties
            %[ndims,nvars,natts,unlimdimID] = netcdf.inq(ncid);
            if nfile==1
                % check initial dates
                disp(' ')
                disp('-------------  new starting time ---------------')
                disp(['num_date',num2str(num_date)])
                disp(['Forecast initial date ',datestr(fdate,'yyyy-mm-dd HH:MM:SS'), ' ; Data: ',netcdf.getAtt(ncid,0,'units')])
                disp('Load data')
                Data.lat=netcdf.getVar(ncid,1);
                %Data.gassw=netcdf.getVar(ncid,2);
                Data.lon=netcdf.getVar(ncid,3);
                %Data.latLonCoordSys=netcdf.getVar(ncid,4);
                %   [varname,vartype,dimids,natts]=netcdf.inqVar(ncid,5);
                 % indices for Haiti latitudes/longitutes
                ind_lat_max=find(Data.lat>max_lat,1,'last');
                ind_lat_min=find(Data.lat<min_lat,1,'first');
                ind_lon_max=find(Data.lon>max_lon,1,'first');
                ind_lon_min=find(Data.lon<min_lon,1,'last');
            
                lat_points=ind_lat_min-ind_lat_max+1;
                lon_points=ind_lon_max-ind_lon_min+1;
                [varname,vartype,dimids,natts] = netcdf.inqVar(ncid,52);
                disp(varname)
            end
           % inquire dimensions
           %[dimname,dimlen] = netcdf.inqDim(ncid,0)
        
            % inquire variables
            %[varname,vartype,dimids,natts] = netcdf.inqVar(ncid,0); varname
        
            % get times
            ftime(nfile)=netcdf.getVar(ncid,0);
            %if norm(double(ftime(nfile))/24.0-double(fdate-idate))> 0
            %    disp([ftime(nfile)/24,fdate,idate])
            %end
            Data.lat1=netcdf.getVar(ncid,1);
            %Data.gassw=netcdf.getVar(ncid,2);
            Data.lon1=netcdf.getVar(ncid,3);
            %Data.latLonCoordSys=netcdf.getVar(ncid,4);
            %   [varname,vartype,dimids,natts]=netcdf.inqVar(ncid,5);
            % indices for Haiti latitudes/longitutes
            if (norm(Data.lat1-Data.lat)>0 || norm(Data.lon1-Data.lon)>0)
                disp('ERROR! latitudes and longitudes change among files')
                return
            end
             % Download data at the correct latitudes
             [varname1,vartype,dimids,natts] = netcdf.inqVar(ncid,52);
             if varname1~=varname
                 disp('ERROR! prate at different location in file')
                return
             end
             prate(:,:,nfile) = netcdf.getVar(ncid, 52, [ind_lon_min-1,ind_lat_max-1,0],[lon_points,lat_points,1]);
             netcdf.close(ncid);
             %fdate=fdate+0.5; % forecasted dates every 6 h (0.25 d)
             fdate=fdate+1.0; % forecasted dates every 24 h (1 d)
        end
       % disp([num2str(idate),' ',num2str(fdate),' ',num2str(nfile)])
       % if fdate-idate >10
       %     file_exists=0
       %     fdate=fdate-0.25;
       % end
    end
    toc
    %disp(['forecasted days:',num2str(nfile/4)])
    disp(['forecasted days:',num2str(nfile/1)])
    
    prate=prate*3600*24; % from Kg/m^2/s to mm/day
    %%interpolation
    [X,Y]=meshgrid(Data.lon(ind_lon_min:ind_lon_max),Data.lat(ind_lat_max:ind_lat_min));
    X=X-360;
    cont=0;
    R_Agg_day=[];
    date_list=[];
    %for i=3:4:nfile
    for i=1:nfile
        cont=cont+1;
        %date_list(cont)=floor(double(idate)+double(ftime(i))/24.0);
        date_list(cont)=floor(double(idate)+i-1);
        %v=mean(prate(:,:,max(i-3,1):i),3);
        %v=double(v');
        v=prate(:,:,i)';
        F = scatteredInterpolant(X(:),Y(:),v(:));
        R_Agg_day(:,cont)=F(centr(:,1),centr(:,2));
    end
    
    %% plot
 %    if num_date==1
 %        cmax=max(max(max(prate)));
 %        Zcentr=cmax*ones(size(centr,1),1);
 %        axlimits=[min(min(X)),max(max(X)),min(min(Y)),max(max(Y))];
 %        climits=[0 20];
 %        fig1=figure(num_date);
 %        
 %        cont=0;
 %        for i=1:size(prate,3)
 %            ptime=double(idate)+double(ftime(i))/24.0;
 %            sub1=subplot(2,1,1);
 %            titlestr=['time ',datestr(double(ptime),'yyyy-mm-dd HH:MM:SS')];
 %            surf(X,Y,prate(:,:,i)')
 %            view(2)
 %            xlabel('long')
 %            ylabel('lat')
 %            axis(axlimits);
 %            title(titlestr)
 %            ax1=gca;
 %            ax1.XTick=X(1,:);
 %            ax1.YTick=Y(end:-1:1,1);
 %            caxis(climits);
 %            colormap(flipud(winter));
 %            c1=colorbar;
 %            ylabel(c1,'prate (mm/day)');
 %            hold on
 %            plot3(centr(:,1),centr(:,2),Zcentr,'xr')
 %            hold off
 %            
 %            sub2=subplot(2,1,2);
 %            if i>cont*4
 %                cont=cont+1;
 %            end
 %            if cont>length(date_list)
 %                cont=length(date_list);
 %            end
 %            %cont=cont+1;
 %            titlestr2=['time ',datestr(double(date_list(cont)),'yyyy-mm-dd HH:MM:SS')];
 %            scatter(centr(:,1),centr(:,2),[],R_Agg_day(:,cont),'filled')
 %            xlabel('long')
 %            ylabel('lat')
 %            axis(axlimits);
 %            title(titlestr2)
 %            ax2=gca;
 %            ax2.XTick=X(1,:);
 %            ax2.YTick=Y(end:-1:1,1);
 %            caxis(climits);
 %            colormap(flipud(winter));
 %            c2=colorbar;
 %            ylabel(c2,'prate (mm/day)');
 %            pause(0.1)
 %        end
 %    end

    %% save results
    filename=['forecast/ws_prate_fore_',datestr(idate,'yyyymmddTHH')];
    save(filename,'date_list','R_Agg_day','AggList','centr')
    disp(date_list)
end
