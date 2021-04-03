% Renata Porciuncula Baptista
% r.baptista@poli.ufrj.br
% Script to initiliaze the image contours

%%
% Root path 
path_data = 'C:\Users\Renata Baptista\Google Drive\FinalProject\Codes\Data\Phantom';
addpath(path_data);


nbInitialImg = 415;
nbFinalImg = 482; % Modify
nbDivisionHealthTumor = 424;
stringBase = 'imagem%d.jpg';

% Generating names and open files
arrayNames = generateFilenamesFromNameBase(stringBase,nbInitialImg, nbFinalImg);
images = imReadArray(arrayNames, path_data, false);

imagesHealthy = images(1:9,:,:);
STEP = 8;
%% Open Draw ROI               
for idx = 1:ceil(size(imagesHealthy,1)/STEP)
    img = squeeze(images((idx-1)*STEP + 1,:,:));
    imshow(img,[0,500])
    roi = roipoly;
    maskfilename = getMaskName(arrayNames((idx-1)*STEP + 1,:));
    imwrite(roi,fullfile(path_data, maskfilename));
end

%% 
