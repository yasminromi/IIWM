function [closestPoint] = findClosestPoint(ptA, arrayPtB)
    %findClosestPoint Given a coordinate A (1x3) find in a array of coordinates B(Nx3) the
    %closest point by euclidean distance
   
    diffArray = (arrayPtB - ptA);
    euclideanDistance = sqrt(diffArray(:,1).^2 + diffArray(:,2).^2 + diffArray(:,3).^2);
    [~,I] = min(euclideanDistance);
    closestPoint = arrayPtB(I,:);
end

