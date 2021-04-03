
function [images_filename,masks, idxNotMasks, masksTrue, GT_filename,ratioPixelMeter,distanceBetweenLayer] = gettingArrays(optionClosedFunction, ...
                                        STEP_IMG, IDX_LAYER, ...
                                        type_init, type_filter, level_processing,...
                                        root)


 

    % ---------------------- TREATING OPTIONAL ARGUMENTS
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
    changeFlag = true;

    [masks, ~ , idxNotMasks] = getMasksToInitializeFromGT(masksTrue, STEP_IMG);

    
end