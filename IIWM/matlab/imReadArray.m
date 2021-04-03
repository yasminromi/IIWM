function [array_output] = imReadArray(filename_array, root_path, flagBin, flagRGB)
    %imReadArray: This function reads an array of filename images of the same size, and
    %return the array images
    % if root_path not passed it assumed None
    
    
    
    % Treating optional argument
     if ~exist('flagRGB','var')
        flagRGB = false;
     end

    % Verifying type
    filename = filename_array(1,:);
    if isstring(filename)
        filename = convertStringsToChars(filename);
    end
   
    % Open one images to get its size to initialize the vector
    NB_IMG = size(filename_array,1);
    if isempty(root_path)
        I = imread(filename); 
    else if (ischar(root_path) && ischar(filename))
        I = imread(fullfile(root_path, filename));
    else
        I = imread(fullfile(str2mat(root_path), str2mat(filename)));
    end    
    N = size(I,1);
    M = size(I,2);
    if flagRGB == 1      
        O = size(I,3);
        array_output = zeros(NB_IMG, N, M, O);
    else
        array_output = zeros(NB_IMG, N, M);
    end
    
    % Load images
    for im = 1:NB_IMG
         filename = filename_array(im,:);
        if isstring(filename)
            filename = convertStringsToChars(filename);
        end
        if contains(filename,'.')
            aux = split(filename,'.');
            if isempty(root_path)
                 I = imread( strcat(aux{1},aux{2}));
            else
                I = imread(fullfile(root_path, aux{1}),aux{2});
            end
        else
            if isempty(root_path)
                I = imread(filename);
            else
                I = imread(fullfile(root_path, filename));
            end
        end
        % imread reads sometimes NxMx3 sometimes NxM - to be verified
        if size(size(I),2) == 3 
           if flagRGB == 0
               if flagBin == true
                    array_output(im,:,:) = imbinarize(rgb2gray(I));
               else
                    array_output(im,:,:) = rgb2gray(I);
               end
           else
                if flagBin == true
                    array_output(im,:,:,:) = imbinarize(I);
               else
                    array_output(im,:,:,:) = I;
               end
           end
        else
            if flagBin == true
                array_output(im,:,:) = imbinarize(I);
            else
                array_output(im,:,:) = I;
            end
        end
    end
end

