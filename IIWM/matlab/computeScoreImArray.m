function [scoreMean, scoreArray] = computeScoreImArray(arrayTrue,arrayEstimated,idxNotMasks, score)
    %Compute Score for an array of images 
    %   Detailed explanation goes here
    
    if isempty(score)
        score = 'iou';
    end
    
    %assert(isequal(size(arrayTrue),size(arrayEstimated)==0),'ImArray must have the same dimensions')
    scoreArray = zeros(size(idxNotMasks,1),1);
    
    if strcmp(score,'iou')
        for idx = idxNotMasks
            scoreArray(idx) = computeIoU(squeeze(arrayTrue(idx,:,:)), ... 
                                         squeeze(arrayEstimated(idx,:,:)));
        end
        scoreMean = mean(nonzeros(scoreArray));
        
    elseif strcmp(score,'acc')
        for idx = idxNotMasks
            aux1 = arrayTrue(idx,:,:);
            aux2 = arrayEstimated(idx,:,:);
            scoreArray(idx) = sum(aux1(:) == aux2(:))/size(aux1(:),1);
        end
        scoreMean = mean(nonzeros(scoreArray));

    else
         error('This metric is not implemented yet, try one of the following list: iou, acc')
    end 
end

