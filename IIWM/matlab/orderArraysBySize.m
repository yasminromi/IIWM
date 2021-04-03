function [Xbig, Ybig, Zbig, Xsmall, Ysmall, Zsmall] = orderArraysBySize(X1,Y1,Z1,X2,Y2,Z2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if size(X1,1) > size(X2,2)
        [Xbig,Ybig,Zbig,Xsmall,Ysmall,Zsmall] = swapArrays(X1,Y1,Z1,X2,Y2,Z2);
    else
        [Xbig,Ybig,Zbig,Xsmall,Ysmall,Zsmall] = swapArrays(X2,Y2,Z2,X1,Y1,Z1);
    end
end

