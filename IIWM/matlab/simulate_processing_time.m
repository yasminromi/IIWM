%script
%to test time
arrayName = generateFilenamesFromNameBase('%04d.jpg',0, 135);
images = imReadArray(arrayName, "C:\Users\Renata Baptista\Google Drive\FinalProject\Codes\Data\Tumor_RedHot\", false, true);
im = squeeze(images(1,:,:));
%%
N = 100;
times = zeros(N,1);
for i=1:N
    t0 =tic;
    %filter = medfilt2(im);
    f = filterWavelet(im,{'HL-LH-HH', 'haar',1});
    times(i) = toc(t0);

end
mean(times)
std(times)

for i = 1:100
    t1 = tic;
 for iMask = 1:2 - 1
        maskCurrent = squeeze(masksGrad(iMask,:,:));
        maskNext = squeeze(masksGrad(iMask+1,:,:));

        % Finding points non null mask Current
        [Xcur, Ycur] = ind2sub(size(maskCurrent), find(maskCurrent));
        [Xnext, Ynext] = ind2sub(size(maskNext), find(maskNext));

        Zcur = ones(size(Xcur)) * (INITIAL_MASK +(iMask-1)*STEP_IMG);
        Znext = ones(size(Xnext)) * (INITIAL_MASK + iMask*STEP_IMG);

        for idxPt=1:size(Xcur,1) % for each point non null in maskCur,
                              % find closest in mask Next
                              % then determine all the points on the line
                              % between and draw then as one in the
                              % maskInterpolated
            ptA = [Xcur(idxPt), Ycur(idxPt), Zcur(idxPt)];
            closestB = findClosestPoint(ptA, [Xnext, Ynext, Znext]);
            coordinates = getCoordinatesOnTheLine(ptA, closestB, STEP_IMG);
            XYZ = round(coordinates);

            % linear indexing to change all points at once
            ind = sub2ind(size(masksInterpolated), XYZ(:,3),XYZ(:,1),XYZ(:,2));  
            masksInterpolated(ind) = 255;

        end
 end
 times(i) = toc(t1);
end


%%
times = zeros(100,1);
for idx = 1:100
           t1 = tic;
        img = squeeze(masksInterpolated(1,:,:));
        closedContour(idx,:,:) = generateClosedContour(img, optionClosedFunction);
    times(idx) = toc(t1);
end
%%

%%

  for idx = 1 
            closedPoly = squeeze(closedContour(idx,:,:));
            closedPoly(closedPoly>0) = 255;
            img = squeeze(masksInterpolated(idx,:,:));
            masksActivated(idx,:,:) = activecontour(squeeze(images(idx,:,:)),...
                                                    closedPoly,...
                                                    'edge',...
                                                    'SmoothFactor',...
                                                    1.,...
                                                    'ContractionBias',...
                                                    0.0);
            contour = squeeze(masksActivated(idx,:,:));

  end
        
  %%
for i = 1:100
           t1 = tic;
        for idx = 1 
            closedPoly = squeeze(closedContour(idx,:,:));
            closedPoly(closedPoly>0) = 255;
            img = squeeze(masksInterpolated(idx,:,:));
            masksActivated(idx,:,:) = activecontour(squeeze(images(idx,:,:)),...
                                                    closedPoly,...
                                                    'edge',...
                                                    'SmoothFactor',...
                                                    1.,...
                                                    'ContractionBias',...
                                                    0.0);
            contour = squeeze(masksActivated(idx,:,:));

  end
    times(i) = toc(t1);
end