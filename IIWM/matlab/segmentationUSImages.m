% Projeto final -  Segmentação de colon de camundongos
% 
% Author: Renata Porciuncula Baptista - r.baptista@poli.ufrj.br
% Orientador: Joao Carlos Machado - jcm@peb.ufrj.br
% Date: 16 August 2019, v1.1 
%        07 September 2019, v2.0


function [masksActivated] = segmentationUSImages(optionClosedFunction, ...
                                        STEP_IMG, IDX_LAYER, ...
                                        type_init, type_filter, level_processing,...
                                        save_option, root)
    
   
    % Warningss
    warning('off', 'Images:initSize:adjustingMag'); % turning off warning size image

    % Briefing about the code
    fprintf('--------------------------------------------------------\n\n');
    fprintf('               SEGMENTATION US SCRIPT                   \n\n');
    fprintf('Author: Renata Baptista\n');
    fprintf('Email: r.baptista@poli.ufrj.br\n');
    fprintf('v2 - 07/09/2019 \n');
    fprintf('--------------------------------------------------------\n\n');

 

    % ---------------------- TREATING OPTIONAL ARGUMENTS
    if ~exist('save_option','var')
      save_option = false;
    end
    if ~exist('type_init','var')
      type_init = 'hull';
    end
    if  ~exist('level_processing', 'var')
        level_processing = 2;
    end
    

    if strcmp(type_init,'normal_animal')
      init_animal; % retorna mask filename, image filename , gt filename
                % STEP_IMG STEP_IMG = 10;
    elseif strcmp(type_init,'phantom')
       init_phantom;
    elseif strcmp(type_init,'tumor')
        init_animal_tumor;
    else
       msg = 'This data has not been implemented yet, try one of the following list: normal_animal, phantom';
       disp(msg);
    end;    
    % ------------------------ PATHS, INITIALIZATION
    % Root path 
    addpath(path_data);

    % Constants
    INITIAL_MASK = 1;
    %NB_IMG = size(images_filename, 1);

    % Load data
    fprintf('Loading images:\n')
    tic;

    % Data
    images = imReadArray(images_filename, path_data, false);
    masksTrue = imReadArray(GT_filename, path_data, true);
    [masks, ~ , idxNotMasks] = getMasksToInitializeFromGT(masksTrue, STEP_IMG);

    % Constant
    NB_MASK = size(masks, 1);

    % Output
    masksInterpolated = zeros(size(images));
    masksActivated = zeros(size(images));
    toc;
    
    %% Filtering
    fprintf('Filtering images:\n')
    tic;
    if ~strcmp(type_filter,'None')
        images = filterArray(images, type_filter);
    else
        disp(['User opt for not filter images'])
    end
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
    if level_processing == 2 
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
    else
        tic;
           masksActivated = masksInterpolated;
        toc;
    end
        
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
     %   figure(idx);
      %  imshow(resu,[0,500]);

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
    if (save_option==true || save_option == 1)
        fprintf('\nSaving images:\n')
        tic;
        name_exp = strcat("mask_algo_step",num2str(STEP_IMG),...
                            "_lay_",num2str(IDX_LAYER),...
                            "_option_",optionClosedFunction,...
                            "filter_", type_filter); 
        mask_algo_filename = createMaskFilename(images_filename, name_exp);
        for idx=1:size(masksActivated,1)
            img = squeeze(masksActivated(idx,:,:));
            i_filename = mask_algo_filename(idx,:)
            imwrite(img,fullfile(root,i_filename));
        end
        toc;
    else
        fprintf('\nUser-choice: NOT save images!\n')
    end
   
    
end