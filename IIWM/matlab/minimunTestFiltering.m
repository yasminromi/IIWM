%Mini test filtering
%
roi = rgb2gray(imread("roi.jpg"));
[a,h,v,d] = haart2(roi,3); 
imshow(a,[])
res = ihaart2(a,zeros(size(h{3})),zeros(size(v{3})),zeros(size(d{3})),3)
result = filterWavelet(roi, {'HL-LH-HH';'haar';1});
imshow(a, [])
%%
fprintf('Loading images:\n')
tic;
IDX_LAYER = 1;
init_animal;
% Data
%images = imReadArray(images_filename, path_data, false);
toc;
images = zeros(1,234,396);
images(1,:,:) = roi;
[filteredArray1] = filterArray(images, 'wlet','HL-LH-HH', 'haar',1);
[filteredArray2] = filterArray(images, 'wlet','HH', 'haar',1);

for im=1:size(images,1)
    figure(im)
    imshow([squeeze(images(im,:,:)) - squeeze(filteredArray1(im,:,:))], []);
end
%imwrite(squeeze(filteredArray(im,:,:)),"roi_wavelet_HH.jpg");
figure(2)
imshow([squeeze(images(im,:,:)) squeeze(filteredArray2(im,:,:))],[0 255]);