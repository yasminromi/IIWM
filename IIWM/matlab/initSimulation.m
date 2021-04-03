function [root,stepOption, layerOption,level_processing] = initSimulation(typeSimulation)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    if(strcmp(typeSimulation, 'phantom'))
        root = './output/phantom/'
        layerOption = [1,2,3,4];
        stepOption = [3,9];
        level_processing = 2;
    elseif(strcmp(typeSimulation, 'phantom_int_only'))
        root = './output/phantom/'
        layerOption = [1,2,3,4];
        stepOption = [3,9];
        level_processing = 1;
    elseif (strcmp(typeSimulation, 'normal_animal')) 
        root = './output/animal/normal_c';
        stepOption = [3,5,6,10,15,30];
        layerOption = [1,2];
        level_processing = 2;

    elseif (strcmp(typeSimulation, 'normal_animal_int_only')) 
        root = './output/animal/normal_c';
        stepOption = [3,5,6,10,15,30];
        layerOption = [1,2];
        level_processing = 1;

    elseif (strcmp(typeSimulation, 'tumor'))
        root = './output/animal/tumor';
        stepOption = [2,5,10,20];
        layerOption = [1];
        level_processing = 2;
    
    elseif (strcmp(typeSimulation, 'tumor_int_only'))
        root = './output/animal/tumor';
        stepOption = [2,5,10,20];
        layerOption = [1];
        level_processing = 1;
    else
        error('This experiment is not implemented yet, try one of the following list: phantom, normal_animal, phantom_int_only, normal_animal_int_only')

    end
    
end

