function [score] = computeIoU(mask1, mask2)
    % IOU Intersection over union score. this function goes here

    % The input expected is two masks of same size

    assert(isequal(size(mask1),size(mask2)),'Masks must have the same dimensions')
    in1 = mask1(:);
    in2 = mask2(:);
    u = nnz(in1 | in2);
    
    if u > 0
        score = nnz(in1 & in2) / u;
    else
        score = 0;
    end    
end

