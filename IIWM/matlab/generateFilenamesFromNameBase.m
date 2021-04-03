function [arrayString] = generateFilenamesFromNameBase(strBase,startNumber, endNumber)
%UNTITLED2 Summary of this function goes here
 idxArray = startNumber:1:endNumber;
 arrayString = string.empty;
 for i=1:size(idxArray,2)
    arrayString(i) = sprintf(strBase,idxArray(i));
 end
 arrayString = arrayString';
end
