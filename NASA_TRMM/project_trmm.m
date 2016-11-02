%project_rainfall to watersheds

clear all
close all

load ../centroids
load prec_nasa.mat

for i=1:length(date_list_nasa)
    i
    R_comm_day(:,i)=interp2(Y_nasa,X_nasa,nasa_X_Y_day(:,:,i),centroids(:,2),centroids(:,1),'nearest')';
   
end

date_list=floor(date_list_nasa);

save prec_nasa_projected
