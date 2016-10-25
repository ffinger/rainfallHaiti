%project_rainfall to watersheds

clear all
close all

reproject_old=false;

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

load prec_nasa

R_WS_day=zeros(length(WS_list),length(date_list_nasa));

parfor node=1:length(WS_list)
    node
    this_mask{node}=find((ws_grid==WS_list(node)));
end
    
if reproject_old
    startidx=1;
else
    oldData=load('prec_nasa_projected');
    startidx=find(date_list_nasa>=oldData.date_list(end),1);
    R_WS_day(:,1:startidx)=oldData.R_WS_day;
end

for i=startidx+1:length(date_list_nasa)
    i
    R=interp2(Y_nasa,X_nasa,nasa_X_Y_day(:,:,i),yy,xx,'nearest')';
    
    parfor n=1:length(WS_list)
        if ismember(WS_list(n),WS_map);
            R_WS_day(n,i)=mean(R(this_mask{n}));
        end
    end
    
end

date_list=floor(date_list_nasa);

save prec_nasa_projected R_WS_day WS_list date_list
