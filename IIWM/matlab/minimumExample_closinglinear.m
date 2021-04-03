    close all;
    
    clc;
    clear;
    %load('maskInterpo.mat')
    
    load('test_interpolated_tumor.mat')
    img = squeeze(masksInterpolated(1,:,:));
    %contour = squeeze(masksActivated(1,:,:));

    [closedPolyHull] = generateClosedContour(img, 'hull')*max(img(:));
    tic;
    %%
    times = zeros(100,1);
    for i=1:100
        t1 = tic;
         [contourClosed] = generateClosedContour(img, 'knn')*max(img(:));
         times(i)= toc(t1);
    end
    %%
    tic;
  %  [contourClosedMatlab] = generateClosedContour(img, 'tsp')*max(img(:));
    toc;
 %%
    %poly2mask(contourClosed)
    toc;
   % closedPoly
    
      imshow([img img+closedPolyHull img+contourClosed
          ])
 %   figure(1);
 %   imshow(contour+closedPolyHull)
 %   figure(2); 
 %   imshow(contour+closedPoly(:,:,1),'gray')

