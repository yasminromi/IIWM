% Projeto final -  Segmentação de colon de camundongos
% 
% Author: Renata Porciuncula Baptista - r.baptista@poli.ufrj.br
% Orientador: Joao Carlos Machado - jcm@peb.ufrj.br
% Date: 16 August 2019, v1.1  

%% Init
clc;
clear all;
close all;

% Root path 
path_data = 'C:\Users\Renata Baptista\Google Drive\FinalProject\Codes\Data\Normal_C';
addpath(path_data);

% Filenames
masks_filename = ['3d0005-mask-out.jpg'; '3d0015-mask-out.jpg'; ...
                 '3d0025-mask-out.jpg'; '3d0035-mask-out.jpg'];
              
images_filename = ['3d0005.jpg'; '3d0006.jpg'; '3d0007.jpg'; ...
                '3d0008.jpg'; '3d0009.jpg'; '3d0010.jpg';
                '3d0011.jpg'; '3d0012.jpg'; '3d0013.jpg';
                '3d0014.jpg'; '3d0015.jpg'; '3d0016.jpg';
                '3d0017.jpg'; '3d0018.jpg'; '3d0019.jpg';
                '3d0020.jpg'; '3d0021.jpg'; '3d0022.jpg';
                '3d0023.jpg'; '3d0024.jpg'; '3d0025.jpg';
                '3d0026.jpg'; '3d0027.jpg'; '3d0028.jpg';
                '3d0029.jpg'; '3d0030.jpg'; '3d0031.jpg';
                '3d0032.jpg'; '3d0033.jpg'; '3d0034.jpg';
                '3d0035.jpg';];

            
% Constants
N_PIXEL = 1000; % size images NxN
NB_MASK = size(masks_filename, 1);
NB_IMG = size(images_filename, 1);
STEP_IMG = 10;
INITIAL_MASK = 1;

% Variables
masks = imReadArray(masks_filename, path_data, true);
images = imReadArray(images_filename, path_data, false);
masksInterpolated = zeros(size(images));

%% Interpolating
% first, getting contours
masksGrad = imGradientArray(masks);

% coordinates of non null
for iMask = 1:1 %NB_MASK - 1
    maskCurrent = squeeze(masksGrad(iMask,:,:));
    maskNext = squeeze(masksGrad(iMask+1,:,:));
    
    % Finding points non null mask Current
    [Xcur, Ycur] = ind2sub(size(maskCurrent), find(maskCurrent));
    [Xnext, Ynext] = ind2sub(size(maskNext), find(maskNext));
    
    Zcur = ones(size(Xcur)) * (INITIAL_MASK +(iMask-1)*STEP_IMG);
    Znext = ones(size(Xnext)) * (INITIAL_MASK + iMask*STEP_IMG);
     
    % If I try to go grom less points to more points, I have a density
    % problem in the masks. So I'll tye the points from the mask that have
    % more to the one which has less
    [Xbig, Ybig, Zbig, Xsmall, Ysmall, Zsmall] = orderArraysBySize(Xcur, Ycur, Zcur, ...
                                                              Xnext, Ynext, Znext);
    
    % freeing some memory
    clear Xcur; clear Ycur; clear Zcur;
    clear Xnext; clear Ynext; clear Zcur;
  
    for idxPt=1:size(Xbig,1) % for each point non null in maskBig,
                          % find closest in mask Small
                          % then determine all the points on the line
                          % between and draw then as one in the
                          % maskInterpolated
        ptA = [Xbig(idxPt), Ybig(idxPt), Zbig(idxPt)];
        closestB = findClosestPoint(ptA, [Xsmall, Ysmall, Zsmall]);
        coordinates = getCoordinatesOnTheLine(ptA, closestB, STEP_IMG);
        XYZ = round(coordinates);
        for idxZ=1:STEP_IMG
            masksInterpolated(XYZ(idxZ,3),XYZ(idxZ,1),XYZ(idxZ,2)) = 255;%255;
        end
    end
end
%%


%% Visualizing the results

for idx=1:10%size(images,1)
    figure(idx)
    imshow(squeeze(masksInterpolated(idx,:,:)))
end

%% Metric Evaluating