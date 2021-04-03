function [idx] = getIndexFromName(filename_us,filename_mask)
  
  numberImages = regexp(cellstr(filename_us),'\d*','Match');
  numberMasks = regexp(cellstr(filename_mask),'\d*','Match');
  
  setImage = getNumberCell(numberImages);
  setMask = getNumberCell(numberMasks);
  
  setImage_modified = eliminateRowWithAllSameValues(sort(setImage));
  setMask_modified = eliminateRowWithAllSameValues(sort(setMask));
  
  [~,idx] = intersect(setImage_modified, setMask_modified);
  idx = idx';
end

