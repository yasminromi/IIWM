function [scoreMeanIou, scoreArrayIou, ...
    scoreMeanAcc, scoreArrayAcc,...
    arrayVolTrue, arrayVolEstimated,...
    volRatio] = evaluateResults(masksTrue,masksEstimated,idxNotMasks, distanceBetweenLayer, ratioPixelMeter, changeFlag)

 %% Metric Evaluating
    fprintf('\nMetric evaluation:\n')
    tic;
    [M,N] = size(squeeze(masksTrue(1,:,:)));
    
    if masksTrue(1,round(M/2),round(N/2)) == 0
        changeFlag = true;
    end
    % Loading masks into memory
    if changeFlag == true
        masksTrue = 1 - masksTrue; % MASKS tao zero na região de interesse
        changeFlag = false;
    end
    % Computing metrics
    [scoreMeanIou, scoreArrayIou] = computeScoreImArray(masksTrue, masksEstimated,...
                                                        idxNotMasks, 'iou');
    [scoreMeanAcc, scoreArrayAcc] = computeScoreImArray(masksTrue, masksEstimated,...
                                                        idxNotMasks, 'acc');
    [volTotalTrue, arrayVolTrue] = computeVolumeFromMasks(masksTrue,...
                                                         distanceBetweenLayer,...
                                                         ratioPixelMeter);
    
    [volTotalEstimated, arrayVolEstimated] = computeVolumeFromMasks(masksEstimated,...
                                                                    distanceBetweenLayer,...
                                                                    ratioPixelMeter);

    volRatio =  sum(arrayVolEstimated(idxNotMasks))/sum(arrayVolTrue(idxNotMasks));
    % output
    fprintf('\tThe score IOU obtained is: %.4f \n', scoreMeanIou);
    fprintf('\tThe score ACC obtained is: %.4f \n', scoreMeanAcc);
    fprintf('\tThe ratio VolEst/VolTrue: %.4f \n', volRatio);

    toc;
end

