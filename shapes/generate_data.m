%
%
clc
clear all
close all
%% some repameter
len = 32;
sizeNeeded = 128; % square
patchNumPerEdge = 3;

data = uint8(zeros(1,32,128,128,3));
save data.mat data
figure
%% process
for i = 1:2
    dirs = dir([int2str(i-1) '/*.png']);
    pic_num = size(dirs, 1);
    for j = 1:size(dirs, 1)
        % process one video
        im = imread(strcat(dirs(j).folder, '/', dirs(j).name));
        % result: [len x sizeNeeded x .. x 3]
        result = process_one_image(im, sizeNeeded, patchNumPerEdge);
%         % show results
%         for k = 1:32
%             imshow(squeeze(result(k,:,:,:)));
%         end
        % save
        curr_data = uint8(zeros(1,32,128,128,3));
        curr_data(1,:,:,:,:) = result;
        load data.mat
        data = cat(1,data,curr_data);
        save data.mat data
    end
end

load data.mat
data = data(2:end,:,:,:,:);
save data.mat data