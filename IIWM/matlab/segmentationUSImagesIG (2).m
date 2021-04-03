% Projeto final -  Segmentação de colon de camundongos
% 
% Author: Renata Porciuncula Baptista - r.baptista@poli.ufrj.br
% Orientador: Joao Carlos Machado - jcm@peb.ufrj.br
% Date: 16 August 2019, v1.1 
%        07 September 2019, v2.0


function [masksActivated,...
         volTotalEstimated,...
         volMasks] = segmentationUSImagesIG(optionClosedFunction, ...
                                        ratioPixelMeter, distanceBetweenLayer,...
                                        images_filename, rootImages, ...
                                        GT_filename, rootMask,...
                                        type_filter,...
                                        level_processing,...
                                        stringTumorLayer,...
                                        IDX_LAYER,...
                                        save_option, root)
    
   
    % Warningss
    warning('off', 'Images:initSize:adjustingMag'); % turning off warning size image

    % Briefing about the code
    fprintf('--------------------------------------------------------\n\n');
    fprintf('               SEGMENTATION US SCRIPT                   \n\n');
    fprintf('Author: Renata Baptista\n');
    fprintf('Email: r.baptista@poli.ufrj.br\n');
    fprintf('v3 - 22/1/2019 \n');
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
    

       
    % ------------------------ PATHS, INITIALIZATION
    % Root path 
    % Constants
    INITIAL_MASK = 1;
    %NB_IMG = size(images_filename, 1);

    % Load data
    fprintf('Loading images:\n')
    tic;

    % Data
    images = imReadArray(images_filename, rootImages, false);
    masks = 255*imReadArray(GT_filename, rootMask, true);
    
    
    maskteste=squeeze(masks(1,:,:));
    
    idxMasksToNotCompute = getIndexFromName(images_filename,GT_filename);
    steps_vector = diff(idxMasksToNotCompute);
    idxMaskToCompute = setdiff(1:size(images_filename,1), idxMasksToNotCompute);
    % Constant
    NB_MASK = size(masks, 1);

    % Output
    masksInterpolated = zeros(size(images));
    masksActivated = zeros(size(images));
    toc;
    
    %% Filtering
    fprintf('\nFiltering images:\n')
    tic;
    if strcmp(type_filter,'None')
         disp(['User opt for not filter images'])
    else
       images = filterArray(images, type_filter);
    end
    toc;
    %% Interpolating
    % first, getting contours
    masksGrad = imGradientArray(masks);

    fprintf('\nInterpolating images between well defined masks:\n')
    tic;
    % coordinates of non null
    cum_step = 0;
    for iMask = 1:NB_MASK - 1
        maskCurrent = squeeze(masksGrad(iMask,:,:));
        maskNext = squeeze(masksGrad(iMask+1,:,:));
        % Finding points non null mask Current
        [Xcur, Ycur] = ind2sub(size(maskCurrent), find(maskCurrent));
        [Xnext, Ynext] = ind2sub(size(maskNext), find(maskNext));

        Zcur = ones(size(Xcur)) * (INITIAL_MASK + cum_step);
        cum_step = cum_step+abs(steps_vector(iMask));
        Znext = ones(size(Xnext)) * (INITIAL_MASK + cum_step);

        for idxPt=1:size(Xcur,1) % for each point non null in maskCur,
                              % find closest in mask Next
                              % then determine all the points on the line
                              % between and draw then as one in the
                              % maskInterpolated
            ptA = [Xcur(idxPt), Ycur(idxPt), Zcur(idxPt)];
            closestB = findClosestPoint(ptA, [Xnext, Ynext, Znext]);
            coordinates = getCoordinatesOnTheLine(ptA, closestB, steps_vector(iMask));
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
    idxMaskToCompute 
    count_mask=1;
    for idx = idxMaskToCompute 
        img = squeeze(masksInterpolated(idx,:,:));
        %closedContour(idx,:,:) = generateClosedContour(img, optionClosedFunction);
        %MODIFICADO EM 10/03/2021
        closedContour(idx,:,:) = generateClosedContour5(img, optionClosedFunction);
        figure(idx)
        imshow(squeeze(closedContour(idx,:,:)),[])
        %size(closedContour(idx,:,:))
        
          %alterado em 5/03/2021
      cd ('C:\Users\DELL\Desktop\mask')
      aux1='Mask';
      aux3='.tif';
      aux2=sprintf('%04d',[idxMaskToCompute(count_mask)]);
      filename=strcat(aux1,aux2,aux3);
      imwrite(squeeze(closedContour(idx,:,:)),filename);
     
      count_mask=count_mask+1;
     
      cd('C:\Rodrigo\Doutorado\Códigos\codigo_modi')
   %#################### FIM DA PARTE PARA SALVAR MÁSCARAS
   
    end
    toc;

     
          
    %% Visualizing final results

    for idx = idxMaskToCompute 

        % Principal variables

        contour = squeeze(closedContour(idx,:,:));
        image = squeeze(images(idx,:,:));
                       
    end
    
%% Computing area
    fprintf('\nComputing volumes:\n')
    tic;
    masksComputed = zeros(size(idxMaskToCompute,2), size(image,1), size(image,2));
    %imshow(masksComputed) %1-03-2021 mostrar as máscaras 

count = 1;
    for idx = idxMaskToCompute
        masksComputed(count,:,:) = closedContour(idx,:,:);
        count = count+ 1;
    end
    
    %sum(sum(closedContour(idx,:,:)))
    %figure(3)
    %imshow(squeeze(closedContour(idx,:,:)))
    
    [volTotalEstimated, arrayVolEstimated] = computeVolumeFromMasks(masksComputed,...
                                                                    distanceBetweenLayer,...
                                                                    ratioPixelMeter);



    fprintf('\t Estimated computed: %.4f mm3 \n', volTotalEstimated*1e9);
     
     mask_ref_int=masks(NB_MASK-1,:,:);
     mask_ref=abs(1-squeeze(mask_ref_int)/255);

    
    [volMasks, ~] = computeVolumeFromMasks(mask_ref,...
                                           distanceBetweenLayer,...
                                           ratioPixelMeter);


fprintf('\t Vol mask passed to the algorithm computed: %.4f mm3 \n', volMasks*1e9);
   

vol_total=volTotalEstimated+volMasks;

fprintf('\t Vol total: %.4f mm3 \n', vol_total*1e9);
      
   
    
end