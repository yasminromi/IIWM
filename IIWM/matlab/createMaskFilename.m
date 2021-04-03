function [masks_filename] = createMaskFilename(image_filename, str_to_be_added)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    masks_filename = string(image_filename);
    if ~exist('str_to_be_added','var')
      str_to_be_added = '_mask_algo';
    end

    for idx=1:size(image_filename,1)
        i_filename = image_filename(idx,:);
        aux = split(i_filename,'.');
       
        masks_filename(idx) = strcat(aux{1},str_to_be_added,'.',aux{2});
    end
end

