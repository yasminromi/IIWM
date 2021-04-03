function [Xorder,Yorder] = sortPointsPolarImproved(img)
%SortPointsPolar takes index cartesian, and sort centering and transform in
%polar coordinates

%   Detailed explanation goes here
     
     [Xcnt, Ycnt] = ind2sub(size(img), find(img));
     [r, c] = size(img);

     % getting center axis
     r = floor(r / 2);
     c = floor(c / 2);
     
     % centering axis
     Xcnt = Xcnt - r;
     Ycnt = Ycnt - c;
     
     % changing coordinates
     [theta, rho] = cart2pol(Xcnt, Ycnt); 
  
     % Ording by theta
     % sort A in descending order (decreasing A values) 
     % and keep the sort index in "sortIdx"
     [theta, sortIdx] = sort(theta, 'descend');
     
     % sort B using the sorting index
     rho = rho(sortIdx);
     
     % Treating the case where theta is equal,
     % the idea is to order ascending or descending depend on
     % the later point different
     
     % indices to unique values in column theta
     [~, ind] = unique(theta);
     % duplicate indices
     
     % For each diferent number
     for idxPtDifferent=1:size(ind,1) - 1
         % create a vector going from this to next different one
         if ind(idxPtDifferent) < ind(idxPtDifferent+1)
            idx_duplicatas = ind(idxPtDifferent):ind(idxPtDifferent+1);
         else
            idx_duplicatas = ind(idxPtDifferent+1):ind(idxPtDifferent);
         end
         % if this size is 1, this mean I have only one point if this 
         % number, i.e, nothing to do. If is bigger: then I order
         % accordingly to point before 
         if size((idx_duplicatas),1) > 1 || size((idx_duplicatas),2)
             rhos_from_thetas_duplicata = rho(idx_duplicatas);
                 if idxPtDifferent ~= 1
                     rho_from_latter_theta = rho(idxPtDifferent - 1);
                     minRho = min(rhos_from_thetas_duplicata);
                     maxRho = max(rhos_from_thetas_duplicata);
                     
                     % More interesting order ascendentgly
                     if abs(rho_from_latter_theta - minRho) < ...
                             abs(rho_from_latter_theta - maxRho)
                        rho_sort = sort(rhos_from_thetas_duplicata, 'ascend');
                     else
                        rho_sort = sort(rhos_from_thetas_duplicata, 'descend');
                     end
                     rho(idx_duplicatas) = rho_sort;
                 end
         end
     end

     
     % Come back to cartesian instruction
     %[Xorder, Yorder] = pol2cart(A(:,1), A(:,2));
     [Xorder, Yorder] = pol2cart(theta, rho);
     
     Xorder = Xorder + r;
     Yorder = Yorder + c;
     
end

%    A = sortrows([theta rho], [1]);
 