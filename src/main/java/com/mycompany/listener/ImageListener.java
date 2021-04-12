package com.mycompany.listener;

import com.mycompany.imagej.Process_Pixels;
import com.mycompany.model.SegmentationUSImageID;
import ij.IJ;
import ij.ImagePlus;

public class ImageListener implements ij.ImageListener {
    private Process_Pixels process;
    private String fileName;
    private SegmentationUSImageID model;

    public ImageListener(Process_Pixels processPixel, SegmentationUSImageID model) {
        this.process = processPixel;
        this.model = model;
    }

    @Override
    public void imageOpened(ImagePlus image) {
        if (image.getOriginalFileInfo() != null) {
            fileName = image.getOriginalFileInfo().fileName;
        }
    }

    @Override
    public void imageClosed(ImagePlus imagePlus) {
    	if(imagePlus != null && imagePlus.getOriginalFileInfo() == null && fileName != null && model != null ) {
            IJ.saveAsTiff(imagePlus, model.getRootMask() + "\\" + fileName.replace(".tif", "_mask.tif"));
        } else {
            process.openNextImage();
        }
    }

    @Override
    public void imageUpdated(ImagePlus imagePlus) { }
}