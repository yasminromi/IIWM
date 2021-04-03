function [masksInitial, idxMasks, idxNotMasks] = getMasksToInitializeFromGT(masksTrue, step)
%getMasksToInitializeFromGT Summary of this function goes here
%   Detailed explanation goes here

    idxMasks = (1:step:size(masksTrue,1));                                        
    masksInitial = masksTrue(idxMasks,:,:);
    idxNotMasks = setdiff(1:1:size(masksTrue,1),idxMasks);
                                       
end

