function [filteredArray] = filterArray(arrayImages, type_filter, varargin)
% This function filters an array of image using one of the following
% filters
 
    filteredArray = zeros(size(arrayImages));
    

    
    % Verifying input
    if nargin<1||isempty(arrayImages),error('Image not selected'),end;
    if nargin<2||isempty(type_filter),error('Specify the filter name to be applied'),end;

    if strcmp(type_filter,'median') || strcmp(type_filter,'Median')
        for im=1:size(arrayImages,1)
            I = squeeze(arrayImages(im,:,:));
            filteredArray(im,:,:) =  medfilt2(I);           
        end
    elseif strcmp(type_filter,'diffuse')
        for im=1:size(arrayImages,1)
            I = squeeze(arrayImages(im,:,:));
            filteredArray(im,:,:) =  imdiffusefilt(I);           
        end
    elseif strcmp(type_filter, 'wlet') || strcmp(type_filter, 'Wavalet')
  
        for im=1:size(arrayImages,1)           
            I = squeeze(arrayImages(im,:,:));
            filteredArray(im,:,:) = filterWavelet(I,varargin);           
        end
    else
       msg = 'This method is not implemented yet, try one of the following list: median, wlet';
       disp(msg);
    end

end

