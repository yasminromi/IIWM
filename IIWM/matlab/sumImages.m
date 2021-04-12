function [I3] = sumImages(rootImages, mask_filename, rootMasks, savePath)

    name_first = regexprep(mask_filename(1,:), "_mask" , "");
    first_image = imread(fullfile(rootImages, name_first));
    [W,H] = size(first_image);
    D = numel(size(mask_filename,1));
    stack = zeros(W,H,D);
    
    for im=1:size(mask_filename,1)  
        
        name = regexprep(mask_filename(im,:), "_mask" , "");
        fprintf(name);
        
        I = imread(fullfile(rootImages, name));
        I4 = imread(fullfile(rootMasks, mask_filename(im,:)));
    
        I3 = imadd(I,I4);
        stack(:,:,im) = I3;
        imwrite(I3, fullfile(savePath, name));
        imwrite(stack(:, :, im), fullfile(savePath, 'final.tif'), 'WriteMode', 'append');
    end
    fprintf('end sum');
   % volumeViewer(stack);
    
   
end