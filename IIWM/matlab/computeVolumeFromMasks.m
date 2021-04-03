function [volTotal, arrayVolume] = computeVolumeFromMasks(masksComputed, distanceBetweenLayer, ratioPixelMeter)
    %ComputeVolumeFromMasks This functions compute the volume of the masks
    %distanceBetweenLayer [m], ratioPixelM [m]
    %based on the distance between the layers and the ratio pixel MM^2

    %  
 
    %arrayVolume = sum(masks, [2 3])*ratioPixelMeter^2*distanceBetweenLayer;
    
    arrayVolume = sum(squeeze(masksComputed))*ratioPixelMeter^2*distanceBetweenLayer;
        
    volTotal = sum(arrayVolume(:));
end

