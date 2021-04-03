function [bAnswer] = isClosed(img)
%IsClosed Verifies if a contour is closed.
%   Detailed explanation goes here

     [Xorder, Yorder] =  sortPointsPolar(img);
     
     % initialize answer
     ptsNotConnected = 0;
     for idx_pt=1:size(Xorder,1)-1
         
         % Getting limits of grid of interested
         minX = min(Xorder(idx_pt), Xorder(idx_pt+1));
         maxX = max(Xorder(idx_pt), Xorder(idx_pt+1));
         minY = min(Yorder(idx_pt), Yorder(idx_pt+1));
         maxY = max(Yorder(idx_pt), Yorder(idx_pt+1));
         
         % verifying if points are not already neighboors
         if ( (maxX-minX)^2 + (maxY-minY)^2 > 2)
             ptsNotConnected = ptsNotConnected + 1;
         end
       
     end
     if ptsNotConnect == 0
         bAnswer = True;
     else
         bAnswer = False;
     end
end

