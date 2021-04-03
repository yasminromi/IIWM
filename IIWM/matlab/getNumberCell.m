function [setImages] = getNumberCell(numberImages)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
  totalImages = size(numberImages,1)*prod(size(numberImages{1},1));

  idx = 1;
  setImages = zeros(totalImages,1);
  for i=1:size(numberImages,1)
      one_cell = numberImages{i};
      for j=1:size(one_cell,2)
        setImages(idx) = str2double(one_cell{j});
        idx = idx + 1;
      end
  end
  setImages = reshape(setImages,[size(one_cell,2),size(numberImages,1)]);
end

