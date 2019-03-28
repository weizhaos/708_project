%
%
clc
clear all
close all
%% some repameter
len = 32;
sizeNeeded = 128; % square
patchNumPerEdge = 3;

figure
%% process
for i = 1:2
    dirs = dir([int2str(i-1) '/*.png']);
    pic_num = size(dirs, 1);
    for j = 1:size(dirs, 1)
        im = imread(strcat(dirs(j).folder, '/', dirs(j).name));
        result = process_one_image(im, sizeNeeded, patchNumPerEdge);
        for k = 1:32
            imshow(squeeze(result(k,:,:,:)));
        end
    end
    break;
end