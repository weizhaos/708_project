% im: 64 x 2048 x 3 uint8
% result: 32 x sizeNeeded x sizeNeeded x 3 uint8
% sizeNeeded: output frame size
% patchNum: patchNum per row/col
function result_scaled = process_one_image(im, sizeNeeded, patchNum)
% get patch size
patch_sz = floor(64/patchNum); 
patch_interval = 1:patch_sz:64;
patch_interval = [patch_interval(1:patchNum), 64];  
% get object color
object_color = squeeze(max(max(im)));
% sample background color
upperBound = 10;
sample_sz = 0;
best_sampled_score = 0; 
best_sampled_background_color = uint8(zeros(3,patchNum^2));
while(sample_sz<upperBound)
    background_color = uint8(randi([0 255], [3,patchNum^2]));
    sample_check = double(background_color)-double(repmat(object_color,1,patchNum^2));
    score = min(sqrt(sum(sample_check .^2, 1)));
    if ( score > best_sampled_score ) 
        best_sampled_score = score;
        best_sampled_background_color = background_color;
    end
    sample_sz = sample_sz + 1;
end
background_color = best_sampled_background_color;
% create background
background = uint8(zeros(64,64,3));
for i = 1:patchNum % rows
    for j = 1:patchNum % cols
        row_size = patch_interval(i+1) - patch_interval(i) + 1;
        col_size = patch_interval(j+1) - patch_interval(j) + 1;
        pixe_color = background_color(:,(i-1)*patchNum+j);
        pixe_color = repmat(pixe_color,1,1,row_size, col_size);
        background(patch_interval(i):patch_interval(i+1), ...
            patch_interval(j):patch_interval(j+1), :) = reshape(permute(pixe_color,[4,3,1,2]),[row_size,col_size,3]);
    end
end
% replicate 32 frames with same background
result = permute(repmat(background,[1,1,1,32]), [4,1,2,3]);
result_scaled = uint8(zeros(32, sizeNeeded, sizeNeeded, 3));
% put in object
for i=1:32
    tmp = im(:,(i-1)*64+1:i*64,:);
    k = find(tmp);
    [r,c,~] = ind2sub([64,64,3], k);
    for j = 1:size(r,1)
        result(i,r(j),c(j),:) = object_color(:);
    end
    result_scaled(i,:,:,:) = imresize(squeeze(result(i,:,:,:)),2);
end

