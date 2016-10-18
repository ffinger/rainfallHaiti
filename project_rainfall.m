%project_rainfall to WS --> with the new ws_grid this takes more than a
%night to run!!!

clear all
close all

load geodata.mat
load ws_grid.txt
clear day_list POPnodes WS_dept adm1_grid degreein degreeout distances down_node up_nodes nnodes outlets

[ttt ncols]=textread('ws_grid.txt','%s %f',1);
[ttt nrows]=textread('ws_grid.txt','%s %f',1,'headerlines',1);
[ttt xll]=textread('ws_grid.txt','%s %f',1,'headerlines',2);
[ttt yll]=textread('ws_grid.txt','%s %f',1,'headerlines',3);
[ttt cellsize]=textread('ws_grid.txt','%s %f',1,'headerlines',4);
[ttt nodata]=textread('ws_grid.txt','%s %f',1,'headerlines',5);

WS_map=unique(ws_grid(:));
WS_map(WS_map==nodata)=[];

xx=(xll+(cellsize/2)):cellsize:(xll+cellsize*size(ws_grid,2)-cellsize/2);
yy=flipud(((yll+(cellsize/2)):cellsize:(yll+cellsize*size(ws_grid,1)-cellsize/2))');
[XX,YY]=meshgrid(xx,yy);
       
clear xll 
clear yll
clear cellsize

WS_list=zeros(length(X),1);
parfor i=1:length(WS_list)
    WS_list(i)=interp2(XX,YY,ws_grid,X(i),Y(i),'nearest');
end


%load rainfall_data

%NASA

load prec_nasa_7Oct2016

R_WS_day=zeros(length(WS_list),length(date_list_nasa));

parfor node=1:length(WS_list)
    node
    this_mask{node}=find((ws_grid==WS_list(node)));
end
    
for i=1:length(date_list_nasa)
    i
    R=interp2(Y_nasa,X_nasa,nasa_X_Y_day(:,:,i),yy,xx,'nearest')';
    
    parfor n=1:length(WS_list)
        if ismember(WS_list(n),WS_map);
            R_WS_day(n,i)=mean(R(this_mask{n}));
        end
    end
    
end

date_list=floor(date_list_nasa);

save prec_nasa_6OOct2016_projected

%NOAA

% load prec_noaa_22Jan13

%keep only data from beginning of Oct 2010, the rest is not useful
% idx=find(date_list_noaa==datenum(2010,10,1));
% date_list_noaa=date_list_noaa(idx:end);
% noaa_Y_X_day=noaa_Y_X_day(:,:,idx:end);
% 
% 
% 
% R_WS_day=zeros(length(WS_list),length(date_list_noaa));
% 
% for i=1:length(date_list_noaa)
%     i
%     
%     R=interp2(Y_noaa,X_noaa-360,noaa_Y_X_day(:,:,i),yy,xx,'nearest'); 
% 
% 
% %     subplot(1,2,1)
% %     imagesc(xx,yy,R)
% %     axis equal
% % % 
% % 
% %     subplot(1,2,2)
% %     imagesc(X_nasa-360,Y_nasa,nasa_Y_X_day(:,:,i))
% %     axis equal
%     
%     %app=zeros(size(ws_grid));
%     for node=1:length(WS_list)
%         if ismember(WS_list(node),WS_map);
%             this_mask=(ws_grid==WS_list(node));
%             R_WS_day(node,i)=mean(R(this_mask));
% %             app(this_mask)=R_WS_day(node,i);
%         end
%     end
% %     subplot(1,2,2)
% %     imagesc(xx,yy,app)
% %     axis equal   
% end
% 
% date_list=date_list_noaa;
% 
% save prec_noaa_22Jan13_projected.mat R_WS_day WS_list date_list
