function [a_modified] = eliminateRowWithAllSameValues(a)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
    idx = [-1];
    for i=1:size(a,1)
        if sum(diff(a(i,:))) ~=0
            idx = i;
        end
    end
    
   a_modified = a(idx,:);
end

