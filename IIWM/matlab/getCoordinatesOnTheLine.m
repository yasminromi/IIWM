function [outputCoordinates] = getCoordinatesOnTheLine(ptA,ptB,nbPoints)
    %GETCOORDINATESONTHELINE This function returns nbPoints points on the line
    %that goes through A and B
    % 17 August 2019
    
    rangeZ = linspace(0,1,nbPoints+1); % If the first z=0, the second z=10
                                       % I want to simulate the, z=0 till
                                       % z = 9
    rangeZ = rangeZ(1:nbPoints);
    outputCoordinates = (ptB-ptA).*rangeZ'+ptA;
  
end

