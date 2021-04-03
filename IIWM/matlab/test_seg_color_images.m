arrayName = generateFilenamesFromNameBase('%04d.jpg',0, 135);
images = imReadArray(arrayName, "C:\Users\Renata Baptista\Google Drive\FinalProject\Codes\Data\Tumor_RedHot\", false, true);

masks = zeros(size(images,1),size(images,2),size(images,3));
%%
for i=1:size(images,1)
    im = squeeze(images(i,:,:,:));
    aux = im(:,:,1)-im(:,:,2);
    %T = graythresh(aux);
            se = strel('disk',5);

    masks(i,:,:) = imopen(aux > 0,se);
    filenameMask = getMaskName(arrayName(i,:));
    imwrite(squeeze(masks(i,:,:)), fullfile("C:\Users\Renata Baptista\Google Drive\FinalProject\Codes\Data\image_c_tumor_proc\",filenameMask));
end

