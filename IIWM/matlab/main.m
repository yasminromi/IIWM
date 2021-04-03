% Projeto final -  Segmentação de colon de camundongos
% 
% Author: Renata Porciuncula Baptista - r.baptista@poli.ufrj.br
% Orientador: Joao Carlos Machado - jcm@peb.ufrj.br
% Date: 16 August 2019, v1.1 
%        07 September 2019, v2.0



%%
% Warningss
warning('off', 'Images:initSize:adjustingMag'); % turning off warning size image

% Briefing about the code
fprintf('--------------------------------------------------------\n\n');
fprintf('               SEGMENTATION US SCRIPT                   \n\n');
fprintf('Author: Renata Baptista\n');
fprintf('Email: r.baptista@poli.ufrj.br\n');
fprintf('v2 - 07/09/2019 \n');
fprintf('--------------------------------------------------------\n\n');

% Options
SAVE = false;
optionClosedFunction = 'linear_imp';
STEP_IMG = 9;
IDX_PHANTOM = 1;

% Initalize some paths
init_animal; % retorna mask filename, image filename , gt filename
            % STEP_IMG STEP_IMG = 10;
%init_phantom;

% Root path 
addpath(path_data);

% Constants
INITIAL_MASK = 1;
NB_IMG = size(images_filename, 1);
changeFlag = true;

% Load data
fprintf('Loading images:\n')
tic;

% Data
images = imReadArray(images_filename, path_data, false);
masksTrue = imReadArray(GT_filename, path_data, true);
[masks, idxMasks, idxNotMasks] = getMasksToInitializeFromGT(masksTrue, STEP_IMG);

% Constant
NB_MASK = size(masks, 1);

% Output
masksInterpolated = zeros(size(images));
masksActivated = zeros(size(images));
toc;

%% Interpolating
% first, getting contours
masksGrad = imGradientArray(masks);

fprintf('\nInterpolating images between well defined masks:\n')
tic;
% coordinates of non null
for iMask = 1:NB_MASK - 1
    maskCurrent = squeeze(masksGrad(iMask,:,:));
    maskNext = squeeze(masksGrad(iMask+1,:,:));

    % Finding points non null mask Current
    [Xcur, Ycur] = ind2sub(size(maskCurrent), find(maskCurrent));
    [Xnext, Ynext] = ind2sub(size(maskNext), find(maskNext));

    Zcur = ones(size(Xcur)) * (INITIAL_MASK +(iMask-1)*STEP_IMG);
    Znext = ones(size(Xnext)) * (INITIAL_MASK + iMask*STEP_IMG);

    for idxPt=1:size(Xcur,1) % for each point non null in maskCur,
                          % find closest in mask Next
                          % then determine all the points on the line
                          % between and draw then as one in the
                          % maskInterpolated
        ptA = [Xcur(idxPt), Ycur(idxPt), Zcur(idxPt)];
        closestB = findClosestPoint(ptA, [Xnext, Ynext, Znext]);
        coordinates = getCoordinatesOnTheLine(ptA, closestB, STEP_IMG);
        XYZ = round(coordinates);

        % linear indexing to change all points at once
        ind = sub2ind(size(masksInterpolated), XYZ(:,3),XYZ(:,1),XYZ(:,2));  
        masksInterpolated(ind) = 255;

    end
end
toc;

% Works well, problem is not continous

%% Closing the mask to initialize active contour
fprintf('\nClosing initial contour:\n')
tic;
closedContour = zeros(size(images));

for idx = idxNotMasks 
    img = squeeze(masksInterpolated(idx,:,:));
    closedContour(idx,:,:) = generateClosedContour(img, optionClosedFunction);
end
toc;

%% Improving contour with active contour
fprintf('\nImproving contours with active contour:\n')
tic;
for idx = idxNotMasks 
    closedPoly = squeeze(closedContour(idx,:,:));
    closedPoly(closedPoly>0) = 255;
    figure(idx)
    img = squeeze(masksInterpolated(idx,:,:));
    masksActivated(idx,:,:) = activecontour(squeeze(images(idx,:,:)),...
                                            closedPoly,...
                                            'edge',...
                                            'SmoothFactor',...
                                            1.,...
                                            'ContractionBias',...
                                            0.0);
    contour = squeeze(masksActivated(idx,:,:));
    imshow([img closedPoly squeeze(images(idx,:,:)) contour])
end

toc;
%% Visualizing final results

for idx = idxNotMasks 

    % Principal variables
    contour = squeeze(masksActivated(idx,:,:));
    image = squeeze(images(idx,:,:));
    valmax = max(max(image));

    % getting contour monochromatic
    SE = strel('disk',1);
    grad = imdilate(contour,SE) - imerode(contour,SE);
    resu = max(image,2.0*valmax*grad);
    figure(idx);
    imshow(resu,[0,500]);

end
%% Computing area
fprintf('\nComputing volumes:\n')
tic;

[volTotalEstimated, arrayVolEstimated] = computeVolumeFromMasks(masksActivated,...
                                                                distanceBetweenLayer,...
                                                                ratioPixelMeter);

fprintf('\t Estimated: %.2f mm3 \n', volTotalEstimated*1e9);
toc;
%% Saving images
if (SAVE==true)
    fprintf('\nSaving images:\n')
    tic;
    mask_algo_filename = createMaskFilename(images_filename);
    for idx=1:size(masksActivated,1)
        img = squeeze(masksActivated(idx,:,:));
        i_filename = mask_algo_filename(idx,:);
        imwrite(img,fullfile(i_filename,output_path));
    end
    toc;
else
    fprintf('\nUser-choice: NOT save images!\n')
end
%% Metric Evaluating
fprintf('\nMetric evaluation:\n')
tic;
% Loading masks into memory
if changeFlag
    masksTrue = 1 - masksTrue; % MASKS tao zero na região de interesse
    changeFlag = false;
end
% Computing metrics
[scoreMeanIou, scoreArrayIou] = computeScoreImArray(masksTrue, masksActivated,...
                                                    idxNotMasks, 'iou');
[scoreMeanAcc, scoreArrayAcc] = computeScoreImArray(masksTrue, masksActivated,...
                                                    idxNotMasks, 'acc');
[volTotalTrue, arrayVolTrue] = computeVolumeFromMasks(masksTrue,...
                                                     distanceBetweenLayer,...
                                                     ratioPixelMeter);


% output
fprintf('\tThe score IOU obtained is: %.4f \n', scoreMeanIou);
fprintf('\tThe score ACC obtained is: %.4f \n', scoreMeanAcc);
fprintf('\tThe ratio VolEst/VolTrue: %.4f \n', sum(arrayVolEstimated(idxNotMasks))/sum(arrayVolTrue(idxNotMasks)));

toc;
