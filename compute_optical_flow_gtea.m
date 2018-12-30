clc;
clear;
addpath(genpath('/home/shubham/Egocentric/fusionseg_for_flow/external_libs/'));
base_dir='/home/shubham/Egocentric/dataset/GTEA/L1_stabilized/';
flow_dir_root='/home/shubham/Egocentric/dataset/GTEA/FusionSeg_flow_L1_stab/';
folders=dir(base_dir);
folders=folders(3:end,:);
[NoF,~]=size(folders);
%flows=zeros(405,720,2);
parfor j=1:NoF
    image_dir = strcat(base_dir, folders(j).name, '/' )
    flow_dir  = strcat(flow_dir_root, folders(j).name, '/')
    cmd = ['mkdir -p ' flow_dir];
    system(cmd);
    image_names = dir([image_dir '*.png']);
    num_img = length(image_names);
    for i=1:num_img
        %tic
        %disp(image_names(i).name);
        if i==num_img
            img1 = imread([image_dir image_names(i).name]);
            img2 = imread([image_dir image_names(i-1).name]);
        else
            img1 = imread([image_dir image_names(i).name]);
            img2 = imread([image_dir image_names(i+1).name]);
        end
        
        [vx,vy,warpI2]=get_optical_flow(img1,img2);
        flow=[];
        flow(:,:,1)=vx;
        flow(:,:,2)=vy;
        flow_img = flowToColor(flow);
        flow_path = [flow_dir image_names(i).name(1:end-3) 'png'];
        imwrite(flow_img,flow_path);
        %toc
    end
end
