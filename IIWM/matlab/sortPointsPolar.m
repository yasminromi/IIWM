function [Xorder,Yorder] = sortPointsPolar(img, centroid_option)
%SortPointsPolar takes index cartesian, and sort centering and transform in
%polar coordinates

%   Detailed explanation goes here
     
     [Xcnt, Ycnt] = ind2sub(size(img), find(img));
     
     if ~exist('centroid_option','var')
        centroid_option = false;
     end
  
     if centroid_option == 0
         [r, c] = size(img);

         % getting center axis
         r = floor(r / 2);
         c = floor(c / 2);
     else
         r = mean(Xcnt);
         c = mean(Ycnt);
     end
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
     
     % Come back to cartesian instruction
     %[Xorder, Yorder] = pol2cart(A(:,1), A(:,2));
     [Xorder, Yorder] = pol2cart(theta, rho);
     
     Xorder = Xorder + r;
     Yorder = Yorder + c;
     
end

%    A = sortrows([theta rho], [1]);
 