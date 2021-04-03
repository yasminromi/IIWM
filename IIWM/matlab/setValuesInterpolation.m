function [Vq,gridX,gridY] = setValuesInterpolation(X1,X2,Y1,Y2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
              minX = min(X1, X2);
             maxX = max(X1, X2);
             minY = min(Y1, Y2);
             maxY = max(Y1, Y2);

            [X, Y] = meshgrid([X1,X2], ...
                                [Y1, Y2 ]); 
            [gridX, gridY] = meshgrid(minX:1:maxX, minY:1:maxY);

             % Values in the points I actually count is 1, it's a contour 
             values = zeros(size(X));

             values(1,1) = 1;
             values(size(values,1),size(values,2)) = 1;

             Vq = interp2(X, Y,  values,...
                         gridX, gridY, 'linear');
end

