% This script's goal is to vary parameter to analyze the segmentation code
% proposed in main

%% Cleaning
clc;
clear all;
close all;

type_exp = 'phantom';
running = false;
computing = true;
[root,stepOption, layerOption,level_processing] = initSimulation(type_exp);

output = './output/simu';
optionClosedFunction = ["hull",  "linear"];
optionFilter = ["none","median","wlet"];
save_option = true;
%%
if running
    for filter = optionFilter
        for option = optionClosedFunction
            for step =  stepOption
                for layer = layerOption
                    name = strcat('op_',option,'__step_',num2str(step), '__layer_',num2str(layer),'__filter_',filter,'.mat');
                   %simu = 0;
                    timerTotal = tic;
                    masksEstimated = segmentationUSImages(option, step, layer,...
                                                        type_exp, filter, level_processing, ...
                                                        save_option, root);
                                                    
                      [~,~, idxNotMasks,...
                   masksTrue, GT_filename,ratioPixelMeter,...
                   distanceBetweenLayer] = gettingArrays(optionClosedFunction, ...
                                        step, layer, ...
                                        type_exp, filter, level_processing,...
                                        root);
                    %compute_results
                    
                    [scoreMeanIou, scoreArrayIou, ...
                     scoreMeanAcc, scoreArrayAcc,...
                    arrayVolTrue, arrayVolEstimated,...
                     volRatio] = evaluateResults(masksTrue,...
                                    masksEstimated,...
                                    idxNotMasks,...
                                    distanceBetweenLayer,...
                                    ratioPixelMeter,...
                                true);
                                
                    time = toc(timerTotal)

                    simu.scenario.option = option;
                    simu.scenario.step = step;
                    simu.scenario.layer = layer;
                    simu.scenario.filter = filter;
                    
                    simu.res.time = time;
                    simu.res.aIoc = scoreArrayIou;
                    simu.res.mIoc = scoreMeanIou;
                    simu.res.aAcc = scoreArrayAcc;
                    simu.res.mAcc = scoreMeanAcc;
                    simu.res.aVolTrue = arrayVolTrue;
                    simu.res.aVolEst = arrayVolEstimated;
                    simu.res.volRatio = volRatio;


                    save(fullfile(root,name), '-struct', 'simu')

                end        
            end
        end
    end
end
%% Computing results
if computing == true

for layer = layerOption
    ant1 = 0;
    ant2 = 0;
        for option = optionClosedFunction
            for step =  stepOption
                 for filter = optionFilter
                    
                    name = strcat('op_',option,'__step_',num2str(step), '__layer_',num2str(layer),'__filter_',filter,'.mat');

                    name_exp = strcat("mask_algo_step",num2str(step),...
                            "_lay_",num2str(layer),...
                            "_option_",option,...
                            "filter_", filter); 
                        
                   [images_filename,masks, idxNotMasks,...
                   masksTrue, GT_filename,ratioPixelMeter,...
                   distanceBetweenLayer] = gettingArrays(optionClosedFunction, ...
                                        step, layer, ...
                                        type_exp, filter, level_processing,...
                                        root); 
                    mask_algo_filename = createMaskFilename(images_filename, name_exp);
                    
                    masksEstimated = imReadArray(mask_algo_filename, root, true);
                   
                    %compute_results                                
                    [scoreMeanIou, scoreArrayIou, ...
                     scoreMeanAcc, scoreArrayAcc,...
                    arrayVolTrue, arrayVolEstimated,...
                     volRatio] = evaluateResults(masksTrue,...
                                    masksEstimated,...
                                    idxNotMasks,...
                                    distanceBetweenLayer,...
                                    ratioPixelMeter,...
                                true);
                                
                  %  time = toc(timerTotal)
                    
                    simu.scenario.option = option;
                    simu.scenario.step = step;
                    simu.scenario.layer = layer;
                    simu.scenario.filter = filter;
                    
                   % simu.res.time = time;
                    simu.res.aIoc = scoreArrayIou;
                    simu.res.mIoc = scoreMeanIou;
                    simu.res.aAcc = scoreArrayAcc;
                    simu.res.mAcc = scoreMeanAcc;
                    simu.res.aVolTrue = arrayVolTrue;
                    simu.res.aVolEst = arrayVolEstimated;
                    simu.res.volRatio = volRatio;

                    if(scoreMeanIou > ant1) && layer == 1
                        best1 = simu;
                    end
                    if(scoreMeanIou > ant2) && layer == 2
                        best2 = simu;
                    end
                    if (layer == 1)
                        ant1 = scoreMeanIou;
                    end
                    if (layer == 2)
                        ant2 = scoreMeanIou;
                    end
                    save(fullfile(root,name), '-struct', 'simu')
                    
                end        
            end
        end
    end
end

%% Loading dat

times = zeros([size(optionFilter,2),size(optionClosedFunction,2),size(stepOption,2),size(layerOption,2)]);
meanScoresAcc = zeros([size(optionFilter,2), size(optionClosedFunction,2),size(stepOption,2),size(layerOption,2)]);
meanScoresIou = zeros([size(optionFilter,2), size(optionClosedFunction,2),size(stepOption,2),size(layerOption,2)]);
volRatios = zeros([size(optionFilter,2), size(optionClosedFunction,2),size(stepOption,2),size(layerOption,2)]);
idx_filter = 1;
for filter = optionFilter
    idx_option = 1;
    for option = optionClosedFunction
        idx_step = 1;
        for step =  stepOption
            idx_layer = 1;
            for layer = layerOption
                name = strcat('op_',option,'__step_',num2str(step), '__layer_',num2str(layer),'__filter_',filter,'.mat');
                simu = load(fullfile(root,name));




                %times(idx_filter, idx_option,idx_step,idx_layer) = simu.res.time;
                meanScoresIou(idx_filter,  idx_option,idx_step,idx_layer) = simu.res.mIoc;
                meanScoresAcc(idx_filter, idx_option,idx_step,idx_layer) = simu.res.mAcc;
                volRatios(idx_filter, idx_option,idx_step,idx_layer) = simu.res.volRatio;


                idx_layer = idx_layer + 1;
            end
            idx_step = idx_step + 1;
        end
        idx_option = idx_option + 1;
    end
    idx_filter = idx_filter + 1;
end
%times(:,:,1) = times(:,:,1);
%times(:,:,2) = times(:,:,2);

%% Ploting
close all;

%ylabel('Time per frame interpolated [m], metric') 
idx_fig = 1;

idx_option = 1;
for option = optionClosedFunction
    idx_layer = 1;
    for layer = layerOption
        
        %--------------- FIG METRICS ------------------------------------
        h = figure(idx_fig);
        idx_fig = idx_fig + 1;
        
        % Mean scores
        plot(stepOption, meanScoresIou(idx_option,:,idx_layer),'--o');
        hold on;
        
        % Volume ratios
        plot(stepOption, volRatios(idx_option,:,idx_layer),'--o');
        hold on;
        
        legend('Average Score IoU', 'Volume Ratio')
        title_str = sprintf('Metrics for different steps - Layer %d - %s', idx_layer, option);
        title(title_str)
        xlabel('Step between between masks input') 
        
        % Saving visual and latex
        filename_png = sprintf('%s - Metrics for different steps - Layer %d - %s.png', type_exp, idx_layer, option);
        filename_eps = sprintf('%s - Metrics for different steps - Layer %d - %s.eps', type_exp, idx_layer, option);
        
                
        saveas(h,fullfile(output,filename_png)); 
        saveas(h,fullfile(output,filename_eps)); 
        
        %---------------------FIGS TIMES-------------------------------
        h = figure(idx_fig);
        idx_fig = idx_fig + 1;
        
        % Time figure
        plot(stepOption, times(idx_option,:,idx_layer)/60,'--o');
       
        legend('Time (min)')
        title_str = sprintf('Computational time (min) for different steps - Layer %d - %s', idx_layer, option);
        title(title_str)
        xlabel('Step between between masks input') 
        
        % Saving visual and latex
        filename_png = sprintf('%s - Computational time (min) for different steps - Layer %d - %s.png', type_exp, idx_layer, option);
        filename_eps = sprintf('%s - Computational time (min) for different steps - Layer %d - %s.eps', type_exp, idx_layer, option);
        
        saveas(h,fullfile(output,filename_png)); 
        saveas(h,fullfile(output,filename_eps)); 
        
        % Iterate layers 
        idx_layer = idx_layer + 1;

    end
    idx_option = idx_option + 1;
end
%%
close all;
%meanScoreIou(:,:,:,1) = meanScoreIou(:,:,:,1) -0.02;

for idx_l =1:size(meanScoresIou,3)
    result_lay_i = squeeze(meanScoresIou(:,:,:));
    results = reshape(result_lay_i, [], size(meanScoresIou,3))
    figure(idx_l)
    plot(stepOption, results,'--o');
        axis([min(stepOption) max(stepOption) 0.99*min(results(:)) 1.01*max(results(:))])

    legend('A','B','C','D','E','F')
    title_str = sprintf('Métrica IoU - Tumor %d ', idx_l);
    title(title_str)
    xlabel('k') 
    ylabel('Iou') 


end