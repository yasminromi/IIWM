function [outputArray] = imGradientArray(imArray)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    
    outputArray = zeros(size(imArray));
    for i=1:size(imArray,1)
        outputArray(i,:,:) = imgradient(squeeze(imArray(i,:,:)));
    end
end

